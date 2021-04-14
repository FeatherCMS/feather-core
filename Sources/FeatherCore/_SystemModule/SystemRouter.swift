//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

struct SystemRouter: RouteCollection {

    let adminController = AdminController()
    let usrfrontend = UserFrontendController()
//
//    let userAdmin = UserAdminController()
//    let roleAdmin = UserRoleAdminController()
//    let permissionAdmin = UserPermissionAdminController()
    
    let userApi = UserApiContentController()
    let roleApi = UserRoleApiContentController()
    let permissionApi = UserPermissionApiContentController()

    let sysAdminController = SystemVariableAdminController()
    let sysApiController = SystemVariableApiContentController()
    
    let frontend = FrontendController()
//    var metadataAdmin = FrontendMetadataModelAdminController()
//    let menuAdmin = FrontendMenuAdminController()
//    let itemAdmin = FrontendMenuItemAdminController()
    let pageAdmin = FrontendPageAdminController()
//
//    let siteAdmin = FrontendSiteAdminController()

    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: usrfrontend.loginView)
        routes.grouped(SystemUserCredentialsAuthenticator()).post("login", use: usrfrontend.login)
        routes.get("logout", use: usrfrontend.logout)
        
        routes.get("sitemap.xml", use: frontend.sitemap)
        routes.get("rss.xml", use: frontend.rss)
        routes.get("robots.txt", use: frontend.robots)
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
        frontendRoutes.get(use: frontend.catchAllView)
        frontendRoutes.get(.catchall, use: frontend.catchAllView)
    }
    
    
    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(SystemModule.pathComponent)
        sysAdminController.setupRoutes(on: modulePath, as: SystemVariableModel.pathComponent)
//
//
//        userAdmin.setupRoutes(on: modulePath, as: SystemUserModel.pathComponent)
//        roleAdmin.setupRoutes(on: modulePath, as: SystemRoleModel.pathComponent)
//        permissionAdmin.setupRoutes(on: modulePath, as: SystemPermissionModel.pathComponent)
//
//        metadataAdmin.setupRoutes(on: modulePath, as: SystemMetadataModel.pathComponent)
//
//        modulePath.get("settings", use: siteAdmin.settingsView)
//        modulePath.post("settings", use: siteAdmin.updateSettings)
//
//        menuAdmin.setupRoutes(on: modulePath, as: SystemMenuModel.pathComponent)
//
//        let itemPath = modulePath.grouped(SystemMenuModel.pathComponent, menuAdmin.idPathComponent)
//        itemAdmin.setupRoutes(on: itemPath, as: SystemMenuItemModel.pathComponent)
//
        pageAdmin.setupRoutes(on: modulePath, as: SystemPageModel.pathComponent)
    }
    
    func publicApiRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(SystemModule.pathComponent)
        modulePath.grouped(SystemUserCredentialsAuthenticator()).post("login", use: userApi.login)
    }
    
    func apiRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(SystemModule.pathComponent)
        sysApiController.setupRoutes(on: modulePath, as: SystemVariableModel.pathComponent)

        userApi.setupRoutes(on: modulePath, as: SystemUserModel.pathComponent)
        roleApi.setupRoutes(on: modulePath, as: SystemRoleModel.pathComponent)
        permissionApi.setupRoutes(on: modulePath, as: SystemPermissionModel.pathComponent)
    }
}
