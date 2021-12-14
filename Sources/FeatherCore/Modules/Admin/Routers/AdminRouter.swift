//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct AdminRouter: FeatherRouter {
    
    func routesHook(args: HookArguments) {
        let middlewares: [Middleware] = args.app.invokeAllFlat(.adminMiddlewares)
        let adminRoutes = args.routes.grouped(Feather.config.paths.admin.pathComponent).grouped(middlewares)
        var arguments = HookArguments()
        arguments.routes = adminRoutes
        let _: [Void] = args.app.invokeAll(.adminRoutes, args: arguments)
    }
    
    func adminRoutesHook(args: HookArguments) {
        let controller = AdminDashboardController()
        args.routes.get(use: controller.renderDashboardTemplate)
        
        args.routes.get("common") { req -> Response in
            let template = AdminModulePageTemplate(req, .init(title: "Common", message: "module information", links: [
                .init(label: "Variables", url: "/admin/common/variables/")
            ]))
            return req.html.render(template)
        }
    }
}
