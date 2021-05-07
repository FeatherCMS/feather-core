//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct AFilter: ContentFilter {
    var key: String = "a"
    
    func filter(_ input: String, _ req: Request) -> EventLoopFuture<String> {
        req.eventLoop.future(input.replacingOccurrences(of: "a", with: "b").replacingOccurrences(of: "A", with: "b"))
    }
    
    
}

struct BFilter: ContentFilter {
    var key: String = "b"
    var priority: Int = 1000
    
    func filter(_ input: String, _ req: Request) -> EventLoopFuture<String> {
        req.eventLoop.future(input.replacingOccurrences(of: "b", with: "c"))
    }
}



final class SystemModule: FeatherModule {

    static var moduleKey: String = "system"

    var bundleUrl: URL? {
        Self.moduleBundleUrl
    }

    func boot(_ app: Application) throws {
        /// middlewares
        app.middleware.use(SystemInstallGuardMiddleware())
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        /// install
        app.hooks.register(.installStep, use: installStepHook)
        app.hooks.register(.installResponse, use: installResponseHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// template
        app.hooks.register(.adminCss, use: adminCssHook)
        app.hooks.register(.adminJs, use: adminJsHook)
//        app.hooks.register(.adminJsInline, use: adminJsInlineHook)
        /// routes
        try SystemRouter().bootAndregisterHooks(app)
        /// pages
        app.hooks.register(.response, use: responseHook)

//        app.hooks.register(.contentFilters, use: contentFiltersHook)
//        app.hooks.register(.adminWidget, use: adminWidgetHook)
//        app.hooks.register("content-actions-template", use: contentActionsTemplate)
    }
    

    
    
    func adminCssHook(args: HookArguments) -> [OrderedTemplateData] {
        [
            .init("admin", order: 500),
        ]
    }
    
    func adminJsHook(args: HookArguments) -> [OrderedTemplateData] {
        [
            .init("admin", order: 500),
        ]
    }

    func adminJsInlineHook(args: HookArguments) -> [OrderedTemplateData] {
        [
            .init("console.warn('hello admin');", order: 500),
        ]
    }
    
    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            SystemTemplateScopeMiddleware(),
        ]
    }
    
    func adminWidgetHook(args: HookArguments) -> EventLoopFuture<View> {
        let req = args.req

        return CommonVariableModel.query(on: req.db).count().and(FrontendPageModel.query(on: req.db).count()).flatMap { pages, variables in
            req.view.render("System/Admin/Widgets/Statistics", [
                "variables": variables,
                "pages": pages,
            ])
        }
    }
    
    func contentFiltersHook(args: HookArguments) -> [ContentFilter] {
        [
            AFilter(),
            BFilter(),
        ]
    }
    
    func contentActionsTemplate(args: HookArguments) -> TemplateDataRepresentable {
        TemplateData.dictionary([
            "js": """
                function clear() {
                    const el = document.getElementsByClassName('editor')[0];
                    //el.value = '';
                    el.select();
                    document.execCommand('copy');
                    window.getSelection().removeAllRanges();
                }
            """,
            "css": """
                
            """,
            "actions": .array([
                .dictionary([
                    "title": "Copy",
                    "icon": "edit-2",
                    "action": "clear()",
                ]),
            ]),
        ])
    }
  
    // MARK: - hooks
    
    func responseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req

        /// if system is not installed yet, perform install process
        guard Application.Config.installed else {
            
            let steps: [[InstallStep]] = req.invokeAll(.installStep)
            let orderedFlatSteps = steps.flatMap { $0 }.sorted { $0.priority > $1.priority }.map { $0.key }
            
            var hookArguments = HookArguments()
            hookArguments.nextInstallStep = InstallStep.finish.key
            let currentStep = Application.Config.installStep ?? InstallStep.start.key
            
            if let currentIndex = orderedFlatSteps.firstIndex(of: currentStep) {
                let nextIndex = orderedFlatSteps.index(after: currentIndex)
                if nextIndex < orderedFlatSteps.count {
                    hookArguments.nextInstallStep = orderedFlatSteps[nextIndex]
                }
            }
            
            let futures: [EventLoopFuture<Response?>] = req.invokeAll(.installResponse, args: hookArguments)
            return req.eventLoop.findFirstValue(futures)
                .flatMapError {
                    req.view.render("System/Install/Error", ["error": $0.localizedDescription])
                        .encodeOptionalResponse(for: req)
                }
        }
        return req.eventLoop.future(nil)
    }
    
    func installStepHook(args: HookArguments) -> [InstallStep] {
        [
            .start,
            .finish,
        ]
    }

    func installResponseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        let currentStep = Application.Config.installStep
        let nextStep = args.nextInstallStep
        let performStep: Bool = req.query["next"] ?? false

        let controller = SystemInstallController()
        if currentStep == nil || currentStep == InstallStep.start.key {
            if performStep {
                return controller.performStartStep(req: req, nextStep: nextStep).map { req.redirect(to: "/install/" + nextStep + "/") }
            }
            return controller.startStep(req: req).encodeOptionalResponse(for: req)
        }
        if currentStep == InstallStep.finish.key {
            if performStep {
                return controller.performFinishStep(req: req).map { req.redirect(to: "/") }
            }
            return controller.finishStep(req: req).encodeOptionalResponse(for: req)
        }
        return req.eventLoop.future(nil)
    }

    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "system",
              item: .init(icon: "settings", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: .init(label: "Dashboard", url: "/admin/system/dashboard/"), permission: nil),
                .init(link: .init(label: "Settings", url: "/admin/system/settings/"), permission: nil),
              ])
    }    
}
