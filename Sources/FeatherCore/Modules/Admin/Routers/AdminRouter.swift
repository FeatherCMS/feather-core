//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct AdminRouter: FeatherRouter {
    
    let controller = AdminDashboardController()
    
    func adminRoutesHook(args: HookArguments) {
        args.routes.get(use: controller.renderDashboardTemplate)
    }
    
    func webRoutesHook(args: HookArguments) {
        let adminMiddlewares: [Middleware] = args.app.invokeAllFlat(.adminMiddlewares)
        let adminRoutes = args.routes
            .grouped(Feather.config.paths.admin.pathComponent)
            .grouped([
                AccessGuardMiddleware(Admin.permission(for: .detail)),
                AdminErrorMiddleware(),
            ])
            .grouped(adminMiddlewares)

        var adminArguments = HookArguments()
        adminArguments.routes = adminRoutes
        let _: [Void] = args.app.invokeAll(.adminRoutes, args: adminArguments)
    }
}
