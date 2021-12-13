//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebRouter: FeatherRouter {
    
//    let pagesController = WebPageAdminController()
    
    func boot(_ app: Application) throws {
        let frontendController = WebFrontendController()
        app.routes.get(Feather.config.paths.sitemap.pathComponent, use: frontendController.renderSitemapTemplate)
        app.routes.get(Feather.config.paths.rss.pathComponent, use: frontendController.renderRssTemplate)
        app.routes.get(Feather.config.paths.robots.pathComponent, use: frontendController.renderRobotsTemplate)
    }

    func routesHook(args: HookArguments) {
        let middlewares: [[Middleware]] = args.app.invokeAll(.webMiddlewares)
        let webRoutes = args.routes.grouped(middlewares.flatMap { $0 })
        var arguments = HookArguments()
        arguments.routes = webRoutes
        let _: [Void] = args.app.invokeAll(.webRoutes, args: arguments)

        webRoutes.get(use: catchAll)
        webRoutes.get(.catchall, use: catchAll)
    }
    
    func adminRoutesHook(args: HookArguments) {
//        accountController.setupAdminRoutes(args.routes)
//        roleController.setupAdminRoutes(args.routes)
//        permissionController.setupAdminRoutes(args.routes)
    }

    func adminApiRoutesHook(args: HookArguments) {
//        accountController.setupAdminApiRoutes(args.routes)
//        roleController.setupAdminApiRoutes(args.routes)
//        permissionController.setupAdminApiRoutes(args.routes)
    }

    // MARK: - helpers

    private func catchAll(_ req: Request) async throws -> Response {
        let res: [Response?] = await req.invokeAll(.webResponse)
        guard let response = res.compactMap({ $0 }).first else {
            throw Abort(.notFound)
        }
        return response
    }
}
