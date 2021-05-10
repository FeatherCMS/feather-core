//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//


struct FrontendRouter: FeatherRouter {
    

    let adminController = FrontendAdminController()
    let frontendController = FrontendController()
    var metadataController = FrontendMetadataController()
    let menuController = FrontendMenuController()
    let menuItemController = FrontendMenuItemController()
    let pageController = FrontendPageController()

    func boot(routes: RoutesBuilder) throws {
        routes.get("sitemap.xml", use: frontendController.sitemap)
        routes.get("rss.xml", use: frontendController.rss)
        routes.get("robots.txt", use: frontendController.robots)
    }

    func webRoutesHook(args: HookArguments) {
        let app = args.app
        let routes = args.routes
        /// if there are other middlewares we add them, finally we append the not found middleware
        let frontendMiddlewaresResult: [[Middleware]] = app.invokeAll(.frontendMiddlewares)
        var frontendMiddlewares = frontendMiddlewaresResult.flatMap { $0 }
        frontendMiddlewares.append(UserAccountSessionAuthenticator())
        frontendMiddlewares.append(FrontendErrorMiddleware())
        let frontendRoutes = routes.grouped(frontendMiddlewares)
        var webArgs = HookArguments()
        webArgs.routes = frontendRoutes
        let _: [Void] = app.invokeAll(.frontendRoutes, args: webArgs)
        
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: frontendController.catchAllView)
        /// NOTE: we only support catching post requests if the app is not installed yet maybe this should be moved to the system module...
        frontendRoutes.post(.catchall, use: frontendController.catchAllView)
    }

    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes

        adminRoutes.get("frontend", use: SystemAdminMenuController(key: "frontend").moduleView)
        
        let frontendAdminRoutes = adminRoutes.grouped(FrontendModule.moduleKeyPathComponent)
        frontendAdminRoutes.get("settings", use: adminController.settingsView)
        frontendAdminRoutes.post("settings", use: adminController.updateSettings)
        
        adminRoutes.register(pageController)
        adminRoutes.register(metadataController)
        adminRoutes.register(menuController)
        adminRoutes.register(menuItemController)
    }
    
    func apiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args.routes
        
        publicApiRoutes.registerPublicApi(pageController)
    }

    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args.routes
        
        apiRoutes.registerApi(pageController)
        apiRoutes.registerApi(metadataController)
        apiRoutes.registerApi(menuController)
        apiRoutes.registerApi(menuItemController)
    }
}
