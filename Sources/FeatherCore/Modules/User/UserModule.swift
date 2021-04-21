//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class UserModule: FeatherModule {

    static var moduleKey: String = "user"

    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// database
        app.databases.middleware.use(UserAccountModelSafeEmailMiddleware())
        
        app.migrations.add(UserMigration_v1())
        /// middlewares
        app.middleware.use(SystemTemplateScopeMiddleware())

        /// install
        app.hooks.register("install-models", use: installModelsHook)
        app.hooks.register("install-permissions", use: installPermissionsHook)
        
        /// acl
        app.hooks.register("permission", use: permissionHook)
        app.hooks.register("access", use: accessHook)
        
        app.hooks.register("admin-auth-middlewares", use: adminAuthMiddlewaresHook)
        app.hooks.register("api-auth-middlewares", use: adminAuthMiddlewaresHook)
        

        /// admin menus
        app.hooks.register("admin-menus", use: adminMenusHook)
        /// routes
        let router = UserRouter()
        try router.boot(routes: app.routes)
        app.hooks.register("admin-routes", use: router.adminRoutesHook)
        app.hooks.register("api-routes", use: router.apiRoutesHook)
        app.hooks.register("api-admin-routes", use: router.apiAdminRoutesHook)
        
    }
  
    // MARK: - hooks
    

    #warning("add back permissions")
    func adminMenusHook(args: HookArguments) -> [FrontendMenu] {
        [
            .init(key: "user",
                  link: .init(label: "User",
                              url: "/admin/user/",
                              icon: "user",
                              permission: nil),
                  items: [
                    .init(label: "Accounts",
                          url: "/admin/user/accounts/",
                          permission: nil),
                    .init(label: "Permissions",
                          url: "/admin/user/permissions/",
                          permission: nil),
                    .init(label: "Roles",
                          url: "/admin/user/roles/",
                          permission: nil),
                  ]),
        ]
    }

    func permissionHook(args: HookArguments) -> Bool {
        let permission = args["permission"] as! Permission
        
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
    
    func adminAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            User.redirectMiddleware(path: "/login/?redirect=/admin/"),
        ]
    }

    #warning("Session auth is only for testing purposes!")
    func apiAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            UserTokenModel.authenticator(),
            User.guardMiddleware(),
        ]
    }
}
