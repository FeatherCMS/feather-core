//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor

struct SystemRouter: FeatherRouter {
    
    func boot(_ app: Application) throws {
        let middlewares: [Middleware] = app.invokeAllFlat(.middlewares)
        let routes = app.routes.grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = routes
        let _: [Void] = app.invokeAll(.routes, args: arguments)
    }
}
