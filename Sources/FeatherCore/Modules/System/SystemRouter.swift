//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct SystemRouter: FeatherRouter {

    let adminController = SystemAdminController()

    func routesHook(args: HookArguments) {
        let app = args.app
        let routes = args.routes

        /// public api routes
        let apiRoutes = routes.grouped("api")
        apiRoutes.get() { _ in ["status": "available"] }
        /// register publicly available api routes
        var apiArgs = HookArguments()
        apiArgs.routes = apiRoutes
        let _: [Void] = app.invokeAll(.apiRoutes, args: apiArgs)

        /// api admin routes
        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let apiMiddlewaresResult: [[Middleware]] = app.invokeAll(.apiMiddlewares)
        var apiMiddlewares = apiMiddlewaresResult.flatMap { $0 }
        apiMiddlewares.append(ValidationErrorMiddleware(environment: app.environment))
        let adminApiRoutes = apiRoutes.grouped(apiMiddlewares).grouped("admin")
        var adminApiArgs = HookArguments()
        adminApiArgs.routes = adminApiRoutes
        let _: [Void] = app.invokeAll(.apiAdminRoutes, args: adminApiArgs)

        /// public web routes
        let webMiddlewaresResult: [[Middleware]] = app.invokeAll(.webMiddlewares)
        let webMiddlewares = webMiddlewaresResult.flatMap { $0 }
        let webRoutes = routes.grouped(webMiddlewares)
        var webArgs = HookArguments()
        webArgs.routes = webRoutes
        let _: [Void] = app.invokeAll(.webRoutes, args: webArgs)
    }
    
    func webRoutesHook(args: HookArguments) {
        let app = args.app
        let routes = args.routes
        /// web admin
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
        systemAdminRoutes.get("modules", use: adminController.modulesView)
    }

}
