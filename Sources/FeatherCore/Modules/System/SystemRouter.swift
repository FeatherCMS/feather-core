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
        let app = args.app
        let routes = args.routes

        // MARK: - api
        let apiRoutes = routes.grouped("api")
        /// register publicly available api routes
        var apiArgs = HookArguments()
        apiArgs.routes = apiRoutes
        let _: [Void] = app.invokeAll(.apiRoutes, args: apiArgs)

        // MARK: - api admin
        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let apiMiddlewaresResult: [[Middleware]] = app.invokeAll(.apiMiddlewares)
        var apiMiddlewares = apiMiddlewaresResult.flatMap { $0 }
        apiMiddlewares.append(ValidationErrorMiddleware(environment: app.environment))
        let adminApiRoutes = apiRoutes.grouped("admin").grouped(apiMiddlewares)
        var adminApiArgs = HookArguments()
        adminApiArgs.routes = adminApiRoutes
        let _: [Void] = app.invokeAll(.apiAdminRoutes, args: adminApiArgs)
        
        // MARK: - admin
        let adminMiddlewaresResult: [[Middleware]] = app.invokeAll(.adminMiddlewares)
        var adminMiddlewares = adminMiddlewaresResult.flatMap { $0 }
        adminMiddlewares.append(AccessGuardMiddleware(SystemModule.permission(for: .custom("admin"))))
        adminMiddlewares.append(SystemAbortErrorMiddleware())
        let adminRoutes = routes.grouped("admin").grouped(adminMiddlewares)
        adminRoutes.get(use: adminController.homeView)
        var adminArgs = HookArguments()
        adminArgs.routes = adminRoutes
        let _: [Void] = app.invokeAll(.adminRoutes, args: adminArgs)
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes

        adminRoutes.get("system", use: SystemAdminMenuController(key: "system").moduleView)

        let systemAdminRoutes = adminRoutes.grouped(SystemModule.moduleKeyPathComponent)
        systemAdminRoutes.get("dashboard", use: adminController.dashboardView)
        systemAdminRoutes.get("settings", use: adminController.settingsView)
        systemAdminRoutes.post("settings", use: adminController.updateSettings)
    }
    
    func apiRoutesHook(args: HookArguments) {
//        let publicApiRoutes = args.routes
    }

    func apiAdminRoutesHook(args: HookArguments) {
//        let apiRoutes = args.routes

    }
    
}
