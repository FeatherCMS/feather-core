//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension HookName {

    static let adminRoutes: HookName = "admin-routes"
    static let adminMiddlewares: HookName = "admin-middlewares"
    static let adminWidgets: HookName = "admin-widgets"
}


struct AdminModule: FeatherModule {
    
    func boot(_ app: Application) throws {
        let router = AdminRouter()
        try router.boot(app)
        
        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
//        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        
        app.hooks.registerAsync("web-menus", use: webMenusHook)
        
    }
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            AdminErrorMiddleware(),
        ]
    }

    func webMenusHook(args: HookArguments) async throws -> [LinkContext] {
        [
            .init(label: "Admin", url: "/admin/")
        ]
    }
    
//    func adminWidgetsHook(args: HookArguments) async throws -> [TemplateRepresentable] {
//        [
//            Div {
//                H2("Statistics")
//                Ul {
//                    Li("Pages: 2")
//                    Li("Variables: 3")
//                }
//            }
//        ]
//    }
}

