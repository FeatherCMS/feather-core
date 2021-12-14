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
        let adminRoutes = args.routes.grouped(Feather.config.paths.api.pathComponent).grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = adminRoutes
        let _: [Void] = args.app.invokeAll(.publicApiRoutes, args: arguments)
    }

    func adminRoutesHook(args: HookArguments) {
        let middlewares: [Middleware] = args.app.invokeAllFlat(.adminApiMiddlewares)
        let adminApiRoutes = args.routes.grouped(Feather.config.paths.api.pathComponent).grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = adminApiRoutes
        let _: [Void] = args.app.invokeAll(.adminApiRoutes, args: arguments)
    }
}
