//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class UserModule: FeatherModule {

    static var moduleKey: String = "user"

    static var bundleUrl: URL? { moduleBundleUrl }

    func boot(_ app: Application) throws {
        /// database
        app.databases.middleware.use(UserAccountModelSafeEmailMiddleware())
        app.migrations.add(UserMigration_v1())
        
        /// install
        app.hooks.register(.installStep, use: installStepHook)
        app.hooks.register(.installResponse, use: installResponseHook)
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        
        /// acl
        app.hooks.register(.permission, use: permissionHook)
        app.hooks.register(.access, use: accessHook)
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.apiMiddlewares, use: apiMiddlewaresHook)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)

        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// routes
        try UserRouter().bootAndRegisterHooks(app)
    }
  
    // MARK: - hooks
    
    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "user",
              item: .init(icon: "user", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: UserAccountModel.adminLink, permission: UserAccountModel.permission(for: .list).identifier),
                .init(link: UserPermissionModel.adminLink, permission: UserPermissionModel.permission(for: .list).identifier),
                .init(link: UserRoleModel.adminLink, permission: UserRoleModel.permission(for: .list).identifier),
              ])
    }

    func permissionHook(args: HookArguments) -> Bool {
        let permission = args.permission
        
        guard let user = args.req.auth.get(User.self) else {
            return false
        }
        if user.isRoot {
            return true
        }
        return user.permissions.contains(permission)
    }
    
    /// by default return the permission as an access...
    func accessHook(args: HookArguments) -> EventLoopFuture<Bool> {
        args.req.eventLoop.future(permissionHook(args: args))
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserTemplateScopeMiddleware()
        ]
    }
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            User.redirectMiddleware(path: "/login/?redirect=/admin/"),
        ]
    }

    func apiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        var middlewares = [
            UserTokenModel.authenticator(),
        ]
        if !Feather.disableApiSessionAuthMiddleware {
            middlewares.append(UserAccountSessionAuthenticator())
        }
        return middlewares + [User.guardMiddleware()]
    }
    
    func installStepHook(args: HookArguments) -> [InstallStep] {
        [
            .init(key: Self.moduleKey, priority: 9000)
        ]
    }

    func installResponseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        let currentStep = args.currentInstallStep
        guard currentStep == Self.moduleKey else {
            return req.eventLoop.future(nil)
        }

        let nextStep = args.nextInstallStep
        let performStep: Bool = req.query["next"] ?? false
        let controller = UserInstallController()
        
        if performStep {
            return controller.performUserStep(req: req, nextStep: nextStep).map {
                if let response = $0 {
                    return response
                }
                return req.redirect(to: "/install/" + nextStep + "/")
            }
        }
        return controller.userStep(req: req).encodeOptionalResponse(for: req)
    }
}
