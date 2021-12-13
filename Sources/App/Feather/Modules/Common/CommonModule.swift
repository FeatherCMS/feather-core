//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct CommonModule: FeatherModule {

    let router = CommonRouter()

    func boot(_ app: Application) throws {
        app.migrations.add(CommonMigrations.v1())
        
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        
        try router.boot(app)
    }
    
    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            CommonVariablesMiddleware(),
        ]
    }
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            CommonVariablesMiddleware(),
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            CommonAdminWidgetTemplate()
        ]
    }
}
