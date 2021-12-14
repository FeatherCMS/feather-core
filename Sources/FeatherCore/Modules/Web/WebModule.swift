//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor
import FeatherCoreApi

public extension HookName {
    static let webResponse: HookName = "web-response"
    static let webRoutes: HookName = "web-routes"
    static let webMiddlewares: HookName = "web-middlewares"
    /// allows to make preparations such as installing models and files

    static let webInstallStep: HookName = "web-install-step"
    static let webInstallResponse: HookName = "web-install-response"
    
    static let install: HookName = "install"
    static let installWebPages: HookName = "install-web-pages"
}

struct WebModule: FeatherModule {
    
    let router = WebRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(WebMigrations.v1())

        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.webResponse, use: webResponseHook)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register("web-menus", use: webMenusHook)
        app.hooks.register(.webInstallStep, use: webInstallStepHook)
        app.hooks.register(.webInstallResponse, use: webInstallResponseHook)
        
        app.hooks.register(.install, use: installHook)
        
        app.hooks.register(.installWebPages, use: installWebPagesHook)
        app.hooks.register(.installCommonVariables, use: installCommonVariablesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminApiRoutes, use: router.adminApiRoutesHook)
        
        try router.boot(app)
    }

    // MARK: - hooks
    
    func installHook(args: HookArguments) async {
        let pages: [WebPage.Create] = await args.req.invokeAllFlat(.installWebPages)
        try! await pages.map { WebPageModel(title: $0.title, content: $0.content) }.create(on: args.req.db)
    }

    func installUserPermissionsHook(args: HookArguments) async -> [UserPermission.Create] {
        var permissions: [UserPermission.Create] = []
        permissions += WebPageModel.createUserPermissions()
        permissions += WebMenuModel.createUserPermissions()
        permissions += WebMenuItemModel.createUserPermissions()
        permissions += WebMetadataModel.createUserPermissions()
        return permissions
    }

    func installWebPagesHook(args: HookArguments) async -> [WebPage.Create] {
        [
            .init(title: "Lorem", content: "ipsum")
        ]
    }
    
    func installCommonVariablesHook(args: HookArguments) async -> [CommonVariable.Create] {
        [
            // MARK: - not found
            
            .init(key: "welcomePageIcon",
                  name: "Welcome page icon",
                  value: "🪶",
                  notes: "Icon of the welcome page"),

            .init(key: "welcomePageTitle",
                  name: "Welcome page title",
                  value: "Welcome",
                  notes: "Title of the welcome page"),
            
            .init(key: "welcomePageExcerpt",
                  name: "Welcome page excerpt",
                  value: "This is your brand new Feather CMS powered website",
                  notes: "Excerpt for the welcome page"),

            .init(key: "welcomePageLinkLabel",
                  name: "Welcome page link label",
                  value: "Start customizing →",
                  notes: "Link label of the welcome page"),

            .init(key: "welcomePageLinkUrl",
                  name: "Welcome page link url",
                  value: "/admin/",
                  notes: "Link URL of the welcome page"),
        ]
    }

    func webResponseHook(args: HookArguments) async -> Response? {
        guard args.req.url.path == "/" else {
            return nil
        }

        let template = WebWelcomeTemplate(args.req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return args.req.html.render(template)
    }

    func webInstallStepHook(args: HookArguments) async -> [FeatherInstallStep] {
        [
            .init(key: "custom", priority: 2),
        ]
    }

    func webInstallResponseHook(args: HookArguments) async -> Response? {
        
        func installPath(for step: String) -> String {
            "/" + Feather.config.paths.install + "/" + step + "/"
        }
        
        let currentStep = Feather.config.install.currentStep
        let nextStep = args.nextInstallStep
        let performStep: Bool = args.req.query[Feather.config.install.nextQueryKey] ?? false
        
        if currentStep == FeatherInstallStep.start.key {
            if performStep {
                let _: [Void] = await args.req.invokeAll(.install)
                Feather.config.install.currentStep = nextStep
                return args.req.redirect(to: installPath(for: nextStep))
            }
            
            let template = WebInstallStepTemplate(args.req, .init(icon: "🪶",
                                                                  title: "Install site",
                                                                  message: "First we have to setup the necessary components.",
                                                                  link: .init(label: "Start installation →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }
        
        if currentStep == "custom" {
            if performStep {
                Feather.config.install.currentStep = nextStep
                return args.req.redirect(to: installPath(for: nextStep))
            }
            
            let template = WebInstallStepTemplate(args.req, .init(icon: "💪",
                                                                  title: "Custom step site",
                                                                  message: "First we have to setup the necessary components.",
                                                                  link: .init(label: "Start installation →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }
        
        if currentStep == FeatherInstallStep.finish.key {
            if performStep {
                Feather.config.install.isCompleted = true
                return args.req.redirect(to: "/")
            }
            let template = WebInstallStepTemplate(args.req, .init(icon: "🪶",
                                                                  title: "Setup completed",
                                                                  message: "Your site is now ready to use.",
                                                                  link: .init(label: "Let's get started →", url: "/install/?next=true")))
            return args.req.html.render(template)
        }

        return nil
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            WebMenuMiddleware(),
            WebErrorMiddleware(),
        ]
    }

    func webMenusHook(args: HookArguments) async -> [LinkContext] {
        [
            .init(label: "Home", url: "/", priority: 100)
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            WebAdminWidgetTemplate(args.req),
        ]
    }
}
