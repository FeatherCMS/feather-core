//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Vapor

public extension HookName {
//    static let response: HookName = "response"
}

struct FileModule: FeatherModule {
    
    let router = FileRouter()
    
    func boot(_ app: Application) throws {
//        app.hooks.register(.middlewares, use: middlewaresHook)
    }

    func config(_ app: Application) throws {
        try router.boot(app)
    }
}

