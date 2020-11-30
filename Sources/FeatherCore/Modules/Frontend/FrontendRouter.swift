//
//  FrontendRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

struct FrontendRouter: ViperRouter {
    
    let frontendController = FrontendController()
    var adminController = FrontendMetadataAdminController()
    
    func boot(routes: RoutesBuilder) throws {
        /// register public sitemap and rss routes
        routes.get("sitemap.xml", use: frontendController.sitemap)
        routes.get("rss.xml", use: frontendController.rss)
        routes.get("robots.txt", use: frontendController.robots)
    }

    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder

        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.hooks.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(FrontendNotFoundMiddleware())

        let frontendRoutes = routes.grouped(frontendMiddlewares)
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: frontendController.catchAllView)
    }

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(FrontendModule.pathComponent)
        adminController.setupRoutes(on: modulePath, as: "metadatas")
    }
}
