//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//


struct UserRouter: RouteCollection {
    
    let webController = UserWebController()
    let userController = UserAccountController()
    let roleController = UserRoleController()
    let permissionController = UserPermissionController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.grouped(UserAccountSessionAuthenticator()).get("login", use: webController.loginView)
        routes.grouped(UserAccountCredentialsAuthenticator()).post("login", use: webController.login)
        routes.grouped(UserAccountSessionAuthenticator()).get("logout", use: webController.logout)
    } 
    
    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes

        adminRoutes.get("user", use: SystemAdminMenuController(key: "user").moduleView)

        adminRoutes.register(userController)
        adminRoutes.register(roleController)
        adminRoutes.register(permissionController)
    }
    
    func apiRoutesHook(args: HookArguments) {
        let publicApiRoutes = args.routes

        publicApiRoutes.grouped(UserAccountCredentialsAuthenticator()).post("login", use: userController.login)
    }

    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args.routes

        apiRoutes.registerApi(userController)
        apiRoutes.registerApi(roleController)
        apiRoutes.registerApi(permissionController)
    }
}
