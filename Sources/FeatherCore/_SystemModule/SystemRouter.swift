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
        routes.grouped(SystemUserSessionAuthenticator()).get("login", use: frontendController.loginView)
        routes.grouped(SystemUserCredentialsAuthenticator()).post("login", use: frontendController.login)
        routes.grouped(SystemUserSessionAuthenticator()).get("logout", use: frontendController.logout)
        
        routes.get("sitemap.xml", use: frontendController.sitemap)
        routes.get("rss.xml", use: frontendController.rss)
        routes.get("robots.txt", use: frontendController.robots)
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
        apiMiddlewares.append(SystemUserSessionAuthenticator())
        apiMiddlewares.append(SystemTokenModel.authenticator())
        apiMiddlewares.append(User.guardMiddleware())
        /// register protected api endpoints
        let adminApiRoutes = apiRoutes.grouped("admin").grouped(apiMiddlewares)
        let _: [Void] = app.invokeAll("api-admin-routes", args: ["routes": adminApiRoutes])
        
        
        let adminMiddlewaresResult: [[Middleware]] = app.invokeAll("admin-auth-middlewares")
        var adminMiddlewares = adminMiddlewaresResult.flatMap { $0 }
        adminMiddlewares.append(SystemUserSessionAuthenticator())
        adminMiddlewares.append(User.redirectMiddleware(path: "/login/?redirect=/admin/"))
        adminMiddlewares.append(AccessGuardMiddleware(.init(namespace: "admin", context: "module", action: .custom("access"))))
        /// groupd admin routes, first we use auth middlewares then the error middleware
        let adminRoutes = routes.grouped("admin").grouped(adminMiddlewares)
        /// setup home view (dashboard)
        adminRoutes.get(use: adminController.homeView)
        adminRoutes.get("dashboard", use: adminController.dashboardView)
        /// hook up other admin views that are protected by the authentication middleware
        let _: [Void] = app.invokeAll("admin-routes", args: ["routes": adminRoutes])

        
        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(SystemUserSessionAuthenticator())
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
        
//        let modulePath = routes.grouped(FileModule.pathComponent)
//        modulePath
//            .grouped(UserAccessMiddleware(name: "file.browser.list"))
//            .get("browser", use: fileAdmin.browserView)
//        
//        let directoryPath = modulePath.grouped("directory")
//            .grouped(UserAccessMiddleware(name: "file.browser.create"))
//        directoryPath.get(use: fileAdmin.directoryView)
//        directoryPath.post(use: fileAdmin.directory)
//
//        let uploadPath = modulePath.grouped("upload")
//            .grouped(UserAccessMiddleware(name: "file.browser.create"))
//        uploadPath.get(use: fileAdmin.uploadView)
//        uploadPath.post(use: fileAdmin.upload)
//
//        let deletePath = modulePath.grouped("delete")
//            .grouped(UserAccessMiddleware(name: "file.browser.delete"))
//        deletePath.get(use: fileAdmin.deleteView)
//        deletePath.post(use: fileAdmin.delete)
        
        adminRoutes.register(userController)
        adminRoutes.register(roleController)
        adminRoutes.register(permissionController)
        adminRoutes.register(pageController)
        adminRoutes.register(variableController)
        adminRoutes.register(metadataController)
        adminRoutes.register(menuController)
        adminRoutes.register(menuItemController)
    }
    
    func apiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args["routes"] as! RoutesBuilder

        publicApiRoutes.grouped(SystemUserCredentialsAuthenticator()).post("login", use: userController.login)
    }

    func apiAdminRoutesHook(args: HookArguments) {
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
