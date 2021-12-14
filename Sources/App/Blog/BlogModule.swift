//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

public extension HookName {

//    static let permission: HookName = "permission"
}

struct BlogModule: FeatherModule {

    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigrations.v1())
        

    }
    
}
