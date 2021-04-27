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
        app.middleware.use(SystemTemplateScopeMiddleware())
        app.middleware.use(SystemInstallGuardMiddleware())
        
        /// install
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// routes
        let router = SystemRouter()
        try router.boot(routes: app.routes)
        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.apiAdminRoutes, use: router.apiAdminRoutesHook)
        /// pages
        app.hooks.register(.response, use: responseHook)
        
//        app.hooks.register(.contentFilters, use: contentFiltersHook)
//        app.hooks.register(.adminWidget, use: adminWidgetHook)
//        app.hooks.register("content-actions-template", use: contentActionsTemplate)
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
                    "icon": "edit",
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
            return SystemInstallController().performInstall(req: req).encodeOptionalResponse(for: req)
        }
        return req.eventLoop.future(nil)
    }

    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "system",
              item: .init(icon: "system", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: .init(label: "Dashboard", url: "/admin/system/dashboard/"), permission: nil),
                .init(link: .init(label: "Settings", url: "/admin/system/settings/"), permission: nil),
              ])
    }    
}
