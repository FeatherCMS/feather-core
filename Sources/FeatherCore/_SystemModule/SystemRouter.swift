//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct SystemRouter: RouteCollection {

    let adminController = SystemAdminController()
    let frontendController = SystemFrontendController()

    let userController = SystemUserController()
    let roleController = SystemRoleController()
    let permissionController = SystemPermissionController()
    let variableController = SystemVariableController()
    var metadataController = SystemMetadataController()
    let menuController = SystemMenuController()
    let menuItemController = SystemMenuItemController()
    let pageController = SystemPageController()

    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: frontendController.loginView)
        routes.grouped(SystemUserCredentialsAuthenticator()).post("login", use: frontendController.login)
        routes.get("logout", use: frontendController.logout)
        
        routes.get("sitemap.xml", use: frontendController.sitemap)
        routes.get("rss.xml", use: frontendController.rss)
        routes.get("robots.txt", use: frontendController.robots)
    }
    
    func routesHook(args: HookArguments) {
        let app = args["app"] as! Application
        let routes = args["routes"] as! RoutesBuilder
        let publicApi = routes.grouped("api")

        /// register publicly available api routes
        let _: [Void] = app.invokeAll("public-api-routes", args: ["routes": publicApi])

        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        let apiMiddlewares: [[Middleware]] = app.invokeAll("api-auth-middlewares")

        /// register protected api endpoints
        let protectedApi = publicApi.grouped(apiMiddlewares.flatMap { $0 })
        let _: [Void] = app.invokeAll("api-routes", args: ["routes": protectedApi])
        
        let adminMiddlewares: [[Middleware]] = app.invokeAll("admin-auth-middlewares")

        /// groupd admin routes, first we use auth middlewares then the error middleware
        let protectedAdmin = routes.grouped("admin").grouped(SystemAdminErrorMiddleware()).grouped(adminMiddlewares.flatMap { $0 })
        /// setup home view (dashboard)
        protectedAdmin.get(use: adminController.homeView)
        protectedAdmin.get("dashboard", use: adminController.dashboardView)
        /// hook up other admin views that are protected by the authentication middleware
        let _: [Void] = app.invokeAll("admin-routes", args: ["routes": protectedAdmin])

        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(SystemNotFoundMiddleware())

        let frontendRoutes = routes.grouped(frontendMiddlewares)
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: frontendController.catchAllView)
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args["routes"] as! RoutesBuilder

        adminRoutes.get("settings", use: adminController.settingsView)
        adminRoutes.post("settings", use: adminController.updateSettings)
        
        
        adminRoutes.register(userController)
        adminRoutes.register(roleController)
        adminRoutes.register(permissionController)
        adminRoutes.register(pageController)
        adminRoutes.register(variableController)
        adminRoutes.register(metadataController)
        adminRoutes.register(menuController)
        adminRoutes.register(menuItemController)
    }
    
    func publicApiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args["routes"] as! RoutesBuilder

        publicApiRoutes.grouped(SystemUserCredentialsAuthenticator()).post("login", use: userController.login)
    }

    func apiRoutesHook(args: HookArguments) {
        let apiRoutes = args["routes"] as! RoutesBuilder

        apiRoutes.registerApi(userController)
        apiRoutes.registerApi(roleController)
        apiRoutes.registerApi(permissionController)
        apiRoutes.registerApi(pageController)
        apiRoutes.registerApi(variableController)
        apiRoutes.registerApi(metadataController)
        apiRoutes.registerApi(menuController)
        apiRoutes.registerApi(menuItemController)
    }
}
