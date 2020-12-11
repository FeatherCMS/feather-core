//
//  FrontendRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

struct FrontendRouter: ViperRouter {
    
    let frontend = FrontendController()
    var metadataAdmin = FrontendMetadataModelAdminController()
    let menuAdmin = FrontendMenuAdminController()
    let itemAdmin = FrontendMenuItemAdminController()
    let pageAdmin = FrontendPageAdminController()
    
    let siteAdmin = FrontendSiteAdminController()
    
    func boot(routes: RoutesBuilder) throws {
        /// register public sitemap and rss routes
        routes.get("sitemap.xml", use: frontend.sitemap)
        routes.get("rss.xml", use: frontend.rss)
        routes.get("robots.txt", use: frontend.robots)
    }

    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder

        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(FrontendNotFoundMiddleware())

        let frontendRoutes = routes.grouped(frontendMiddlewares)
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontend.catchAllView)
        frontendRoutes.get(.catchall, use: frontend.catchAllView)
    }

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(FrontendModule.pathComponent)
        metadataAdmin.setupRoutes(on: modulePath, as: FrontendMetadataModel.pathComponent)

        modulePath.get("settings", use: siteAdmin.settingsView)
        modulePath.post("settings", use: siteAdmin.updateSettings)
        
        menuAdmin.setupRoutes(on: modulePath, as: FrontendMenuModel.pathComponent)

        let itemPath = modulePath.grouped(.init(stringLiteral: FrontendMenuModel.name), menuAdmin.idPathComponent)
        itemAdmin.setupRoutes(on: itemPath, as: FrontendMenuItemModel.pathComponent)
        
        pageAdmin.setupRoutes(on: modulePath, as: FrontendPageModel.pathComponent)
    }
}
