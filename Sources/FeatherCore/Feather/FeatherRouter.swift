//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//


public protocol FeatherRouter: RouteCollection {

    func routesHook(args: HookArguments)
    func webRoutesHook(args: HookArguments)
    func frontendRoutesHook(args: HookArguments)
    func adminRoutesHook(args: HookArguments)
    func apiRoutesHook(args: HookArguments)
    func apiAdminRoutesHook(args: HookArguments)
    
    func bootAndregisterHooks(_ app: Application) throws
}

public extension FeatherRouter {

    func boot(routes: RoutesBuilder) throws {}
    
    func routesHook(args: HookArguments) {}

    func webRoutesHook(args: HookArguments) {}
    
    func frontendRoutesHook(args: HookArguments) {}

    func adminRoutesHook(args: HookArguments) {}
    
    func apiRoutesHook(args: HookArguments) {}

    func apiAdminRoutesHook(args: HookArguments) {}

    func bootAndregisterHooks(_ app: Application) throws {
        try boot(routes: app.routes)
        app.hooks.register(.routes, use: routesHook)
        app.hooks.register(.webRoutes, use: webRoutesHook)
        app.hooks.register(.frontendRoutes, use: frontendRoutesHook)
        app.hooks.register(.adminRoutes, use: adminRoutesHook)
        app.hooks.register(.apiRoutes, use: apiRoutesHook)
        app.hooks.register(.apiAdminRoutes, use: apiAdminRoutesHook)
    }
}
