//
//  AdminRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

struct AdminRouter: ViperRouter {
    
    let adminController = AdminController()

    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder

        let middlewares: [[Middleware]] = app.invokeAll("admin-auth-middlewares")

        /// groupd admin routes, first we use auth middlewares then the error middleware
        let protectedAdmin = routes.grouped("admin").grouped(AdminErrorMiddleware()).grouped(middlewares.flatMap { $0 })
        /// setup home view (dashboard)
        protectedAdmin.get(use: adminController.homeView)
        /// hook up other admin views that are protected by the authentication middleware
        let _: [Void] = app.invokeAll("admin", args: ["routes": protectedAdmin])
    }
}
