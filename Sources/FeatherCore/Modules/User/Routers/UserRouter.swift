//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

struct UserRouter: FeatherRouter {
    
    let authController = UserAuthController()
    let accountController = UserAccountAdminController()
    let roleController = UserRoleAdminController()
    let permissionController = UserPermissionAdminController()

    
    func webRoutesHook(args: HookArguments) {
        args.routes.grouped(UserAccountSessionAuthenticator())
            .get(args.app.feather.config.paths.login.pathComponent, use: authController.loginView)
        args.routes.grouped(UserAccountCredentialsAuthenticator())
            .post(args.app.feather.config.paths.login.pathComponent, use: authController.login)
        args.routes.grouped(UserAccountSessionAuthenticator())
            .get(args.app.feather.config.paths.logout.pathComponent, use: authController.logout)
    }
    
    func adminRoutesHook(args: HookArguments) {
        accountController.setUpRoutes(args.routes)
        roleController.setUpRoutes(args.routes)
        permissionController.setUpRoutes(args.routes)
        
        args.routes.get(User.pathKey.pathComponent) { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "User",
                                                         tag: UserAdminWidgetTemplate().render(req)))
            return req.templates.renderHtml(template)
        }
    }
    
    func publicApiRoutesHook(args: HookArguments) {
        args.routes
            .grouped(UserAccountCredentialsAuthenticator())
            .post(args.app.feather.config.paths.login.pathComponent, use: authController.loginApi)
    }

    func apiRoutesHook(args: HookArguments) {
//        accountController.setupApiRoutes(args.routes)
//        roleController.setupApiRoutes(args.routes)
//        permissionController.setupApiRoutes(args.routes)
    }
}
