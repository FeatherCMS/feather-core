//
//  UserRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

struct UserRouter: ViperRouter {
    
    let frontend = UserFrontendController()
    
    let userAdmin = UserAdminController()
    let roleAdmin = UserRoleAdminController()
    let permissionAdmin = UserPermissionAdminController()
    

    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: frontend.loginView)
        routes.grouped(UserModelCredentialsAuthenticator()).post("login", use: frontend.login)
        routes.get("logout", use: frontend.logout)
    }

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(UserModule.pathComponent)

        userAdmin.setupRoutes(on: modulePath, as: UserModel.pathComponent)
        roleAdmin.setupRoutes(on: modulePath, as: UserRoleModel.pathComponent)
        permissionAdmin.setupRoutes(on: modulePath, as: UserPermissionModel.pathComponent)
    }
}
