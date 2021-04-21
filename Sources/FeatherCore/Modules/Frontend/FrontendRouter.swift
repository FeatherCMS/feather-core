//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//


struct FrontendRouter: RouteCollection {

    let frontendController = FrontendWebController()
    var metadataController = FrontendMetadataController()
    let menuController = FrontendMenuController()
    let menuItemController = FrontendMenuItemController()
    let pageController = FrontendPageController()

    func boot(routes: RoutesBuilder) throws {
        routes.get("sitemap.xml", use: frontendController.sitemap)
        routes.get("rss.xml", use: frontendController.rss)
        routes.get("robots.txt", use: frontendController.robots)
        
        
    }
    
    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder
        #warning("web-middlewares")
        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(UserAccountSessionAuthenticator())
        frontendMiddlewares.append(FrontendNotFoundMiddleware())
        
        let frontendRoutes = routes.grouped(frontendMiddlewares)
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: frontendController.catchAllView)
    }

    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args["routes"] as! RoutesBuilder

        adminRoutes.get("frontend", use: SystemAdminMenuController(key: "frontend").moduleView)
        
        adminRoutes.register(pageController)
        adminRoutes.register(metadataController)
        adminRoutes.register(menuController)
        adminRoutes.register(menuItemController)
    }
    
    func apiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args["routes"] as! RoutesBuilder

    }

    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args["routes"] as! RoutesBuilder

        apiRoutes.registerApi(pageController)
        apiRoutes.registerApi(metadataController)
        apiRoutes.registerApi(menuController)
        apiRoutes.registerApi(menuItemController)
    }
}
