//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class UserModule: FeatherModule {

    static var moduleKey: String = "user"

    var bundleUrl: URL? {
        Self.moduleBundleUrl
    }

    func boot(_ app: Application) throws {
        /// database
        app.databases.middleware.use(UserAccountModelSafeEmailMiddleware())
        
        app.migrations.add(UserMigration_v1())
        /// middlewares
        app.middleware.use(UserTemplateScopeMiddleware())

        /// install
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        
        /// acl
        app.hooks.register(.permission, use: permissionHook)
        app.hooks.register(.access, use: accessHook)
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.apiMiddlewares, use: apiMiddlewaresHook)
        

        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// routes
        let router = UserRouter()
        try router.boot(routes: app.routes)
        app.hooks.register(.webRoutes, use: router.webRoutesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.apiAdminRoutes, use: router.apiAdminRoutesHook)
        
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
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            User.redirectMiddleware(path: "/login/?redirect=/admin/"),
        ]
    }

    #warning("Session auth is only for testing purposes!")
    func apiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            UserTokenModel.authenticator(),
            User.guardMiddleware(),
        ]
    }
}
