//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct SystemRouter: RouteCollection {

    let adminController = SystemAdminController()

    func boot(routes: RoutesBuilder) throws {
        
    }
    
    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder

        // MARK: - api
        let apiRoutes = routes.grouped("api")
        /// register publicly available api routes
        let _: [Void] = app.invokeAll("api-routes", args: ["routes": apiRoutes])

        // MARK: - api admin
        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let apiMiddlewaresResult: [[Middleware]] = app.invokeAll("api-auth-middlewares")
        let apiMiddlewares = apiMiddlewaresResult.flatMap { $0 }
        let adminApiRoutes = apiRoutes.grouped("admin").grouped(apiMiddlewares)
        let _: [Void] = app.invokeAll("api-admin-routes", args: ["routes": adminApiRoutes])
        
        // MARK: - admin
        let adminMiddlewaresResult: [[Middleware]] = app.invokeAll("admin-auth-middlewares")
        var adminMiddlewares = adminMiddlewaresResult.flatMap { $0 }
        adminMiddlewares.append(AccessGuardMiddleware(SystemModule.permission(for: .custom("admin"))))
        adminMiddlewares.append(SystemAbortErrorMiddleware())
        let adminRoutes = routes.grouped("admin").grouped(adminMiddlewares)
        adminRoutes.get(use: adminController.homeView)
        let _: [Void] = app.invokeAll("admin-routes", args: ["routes": adminRoutes])
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args["routes"] as! RoutesBuilder

        adminRoutes.get("system", use: SystemAdminMenuController(key: "system").moduleView)

        let systemAdminRoutes = adminRoutes.grouped(SystemModule.moduleKeyPathComponent)
        systemAdminRoutes.get("dashboard", use: adminController.dashboardView)
        systemAdminRoutes.get("settings", use: adminController.settingsView)
        systemAdminRoutes.post("settings", use: adminController.updateSettings)
    }
    
    func apiRoutesHook(args: HookArguments) {
//        let publicApiRoutes = args["routes"] as! RoutesBuilder
    }

    func apiAdminRoutesHook(args: HookArguments) {
//        let apiRoutes = args["routes"] as! RoutesBuilder

    }
    
}
