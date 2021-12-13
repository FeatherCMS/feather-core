//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension HookName {

    static let routes: HookName = "routes"
    static let middlewares: HookName = "middlewares"
}

struct SystemModule: FeatherModule {
    
    func config(_ app: Application) throws {
        let middlewares: [[Middleware]] = app.invokeAll(.middlewares)
        let routes = app.routes.grouped(middlewares.flatMap { $0 })
        var arguments = HookArguments()
        arguments.routes = routes
        let _: [Void] = app.invokeAll(.routes, args: arguments)
    }
}
