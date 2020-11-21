//
//  UserRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

struct UserRouter: ViperRouter {
    
    let frontendController = UserFrontendController()
    let adminController = UserAdminController()

    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: frontendController.loginView)
        routes.grouped(UserModelCredentialsAuthenticator()).post("login", use: frontendController.login)
        routes.get("logout", use: frontendController.logout)
    }

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(UserModule.pathComponent)
        adminController.setupRoutes(on: modulePath, as: UserModel.pathComponent)
    }
}
