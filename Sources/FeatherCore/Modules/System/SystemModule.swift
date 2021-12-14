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
    static let response: HookName = "response"
}

struct SystemModule: FeatherModule {
    
    let router = SystemRouter()
    
    func boot(_ app: Application) throws {
        app.hooks.register(.middlewares, use: middlewaresHook)
    }

    func config(_ app: Application) throws {
        try router.boot(app)
    }
    
    func middlewaresHook(args: HookArguments) -> [Middleware] {
        [
            SystemInstallGuardMiddleware()
        ]
    }
    
    
}

