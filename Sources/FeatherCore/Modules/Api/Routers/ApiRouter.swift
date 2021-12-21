//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct ApiRouter: FeatherRouter {

    func routesHook(args: HookArguments) {
        let middlewares: [Middleware] = args.app.invokeAllFlat(.publicApiMiddlewares)
        let apiRoutes = args.routes.grouped(Feather.config.paths.api.pathComponent).grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = apiRoutes
        let _: [Void] = args.app.invokeAll(.publicApiRoutes, args: arguments)
        
        let adminMiddlewares: [Middleware] = args.app.invokeAllFlat(.adminApiMiddlewares)
        let adminApiRoutes = apiRoutes.grouped(Feather.config.paths.admin.pathComponent).grouped(adminMiddlewares)
        var adminArguments = HookArguments()
        adminArguments.routes = adminApiRoutes
        let _: [Void] = args.app.invokeAll(.adminApiRoutes, args: adminArguments)
    }
}
