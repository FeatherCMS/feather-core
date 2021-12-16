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

    let router = BlogRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigrations.v1())
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)

    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            BlogAdminWidgetTemplate(args.req),
        ]
    }
}
