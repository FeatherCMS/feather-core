//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct SystemRouter: RouteCollection {

    let adminController = SystemAdminController()
    let frontendController = FrontendWebController()

    let fileController = SystemFileController()
    let userController = UserAccountController()
    let roleController = UserRoleController()
    let permissionController = UserPermissionController()
    let variableController = SystemVariableController()
    var metadataController = FrontendMetadataController()
    let menuController = FrontendMenuController()
    let menuItemController = FrontendMenuItemController()
    let pageController = FrontendPageController()

    func boot(routes: RoutesBuilder) throws {
        routes.grouped(UserAccountSessionAuthenticator()).get("login", use: frontendController.loginView)
        routes.grouped(UserAccountCredentialsAuthenticator()).post("login", use: frontendController.login)
        routes.grouped(UserAccountSessionAuthenticator()).get("logout", use: frontendController.logout)
        
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
        adminRoutes.get("system", use: FeatherAdminMenuController(key: "system").moduleView)
        adminRoutes.get("web", use: FeatherAdminMenuController(key: "web").moduleView)
        adminRoutes.get("user", use: FeatherAdminMenuController(key: "user").moduleView)
        /// setup dasbhoard & settings routes
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).get("dashboard", use: adminController.dashboardView)
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).get("settings", use: adminController.settingsView)
        adminRoutes.grouped(SystemModule.moduleKeyPathComponent).post("settings", use: adminController.updateSettings)
        
        /// hook up other admin views that are protected by the authentication middleware
        let _: [Void] = app.invokeAll("admin-routes", args: ["routes": adminRoutes])

        
        /// if there are other middlewares we add them, finally we append the not found middleware
        let middlewares: [[Middleware]] = app.invokeAll("frontend-middlewares")
        var frontendMiddlewares = middlewares.flatMap { $0 }
        frontendMiddlewares.append(UserAccountSessionAuthenticator())
        frontendMiddlewares.append(SystemNotFoundMiddleware())

        let frontendRoutes = routes.grouped(frontendMiddlewares)
        /// handle root path and everything else via the controller method
        frontendRoutes.get(use: frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: frontendController.catchAllView)
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args["routes"] as! RoutesBuilder

        let modulePath = adminRoutes.grouped(SystemModule.moduleKeyPathComponent)
        modulePath
            .grouped(AccessGuardMiddleware(.init(namespace: "system", context: "files", action: .list)))
            .get("files", use: fileController.browserView)

        let directoryPath = modulePath.grouped("files").grouped("directory")
            .grouped(AccessGuardMiddleware(.init(namespace: "system", context: "files", action: .create)))
        directoryPath.get(use: fileController.directoryView)
//        directoryPath.post(use: fileController.directory)

        let uploadPath = modulePath.grouped("files").grouped("upload")
            .grouped(AccessGuardMiddleware(.init(namespace: "system", context: "files", action: .create)))
        uploadPath.get(use: fileController.uploadView)
//        uploadPath.post(use: fileController.upload)

        let deletePath = modulePath.grouped("files").grouped("delete")
            .grouped(AccessGuardMiddleware(.init(namespace: "system", context: "files", action: .delete)))
//        deletePath.get(use: fileController.deleteView)
//        deletePath.post(use: fileController.delete)
        
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

        publicApiRoutes.grouped(UserAccountCredentialsAuthenticator()).post("login", use: userController.login)
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
