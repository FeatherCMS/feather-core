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

        let apiRoutes = routes.grouped("api")
        /// register publicly available api routes
        let _: [Void] = app.invokeAll("api-routes", args: ["routes": apiRoutes])

        
        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let apiMiddlewaresResult: [[Middleware]] = app.invokeAll("api-auth-middlewares")
        var apiMiddlewares = apiMiddlewaresResult.flatMap { $0 }
        #warning("Session auth is only for testing purposes!")
        apiMiddlewares.append(UserAccountSessionAuthenticator())
        apiMiddlewares.append(UserTokenModel.authenticator())
        apiMiddlewares.append(User.guardMiddleware())
        /// register protected api endpoints
        let adminApiRoutes = apiRoutes.grouped("admin").grouped(apiMiddlewares)
        let _: [Void] = app.invokeAll("api-admin-routes", args: ["routes": adminApiRoutes])
        
        
        let adminMiddlewaresResult: [[Middleware]] = app.invokeAll("admin-auth-middlewares")
        var adminMiddlewares = adminMiddlewaresResult.flatMap { $0 }
        adminMiddlewares.append(UserAccountSessionAuthenticator())
        adminMiddlewares.append(User.redirectMiddleware(path: "/login/?redirect=/admin/"))
        adminMiddlewares.append(AccessGuardMiddleware(.init(namespace: "system", context: "module", action: .custom("admin"))))
        adminMiddlewares.append(SystemAbortErrorMiddleware())
        /// groupd admin routes, first we use auth middlewares then the error middleware
        let adminRoutes = routes.grouped("admin").grouped(adminMiddlewares)
        /// setup home view (dashboard)
        adminRoutes.get(use: adminController.homeView)
        /// setup module related admin routes
        adminRoutes.get("system", use: SystemAdminMenuController(key: "system").moduleView)
        adminRoutes.get("web", use: SystemAdminMenuController(key: "web").moduleView)
        adminRoutes.get("user", use: SystemAdminMenuController(key: "user").moduleView)
        /// setup dasbhoard & settings routes
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).get("dashboard", use: adminController.dashboardView)
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).get("settings", use: adminController.settingsView)
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).post("settings", use: adminController.updateSettings)
        
        /// hook up other admin views that are protected by the authentication middleware
        let _: [Void] = app.invokeAll("admin-routes", args: ["routes": adminRoutes])
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args["routes"] as! RoutesBuilder

        
    }
    
    func apiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args["routes"] as! RoutesBuilder

        
    }

    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args["routes"] as! RoutesBuilder


    }
}
