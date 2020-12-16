//
//  UserModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

final class UserModule: ViperModule {

    static let name = "user"
    var priority: Int { 8000 }
    
    var router: ViperRouter? = UserRouter()
    
    var middlewares: [Middleware] = [
        UserModelSessionAuthenticator()
    ]

    var migrations: [Migration] {
        [
            UserMigration_v1_0_0(),
        ]
    }

    static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Modules")
            .appendingPathComponent(name.capitalized)
    }
    
    func leafDataGenerator(for req: Request) -> [String: LeafDataGenerator]? {
        var res: [String: LeafDataGenerator] = [
            "isAuthenticated": .lazy(LeafData.bool(req.auth.has(UserModel.self)))
        ]
        if let user = try? req.auth.require(UserModel.self) {
            res["email"] = .lazy(LeafData.string(user.email))
        }
        return res
    }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(UserModelContentMiddleware())

        /// install
        app.hooks.register("model-install", use: modelInstallHook)
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
        
        /// admin
        app.hooks.register("admin", use: (router as! UserRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        
        /// permission / access
        app.hooks.register("access", use: accessHook)
        app.hooks.register("leaf-permission-hook", use: leafPermissionHook)
        
        /// auth
        app.hooks.register("admin-auth-middlewares", use: adminAuthMiddlewaresHook)
        app.hooks.register("api-auth-middlewares", use: apiAuthMiddlewaresHook)
        
        //app.hooks.register("system-variables-list-access", use: systemVariablesAccessHook)
    }
    
    // MARK: - hook functions

   
    
    func adminAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [UserModel.redirectMiddleware(path: "/login/?redirect=/admin/"), UserAccessMiddleware(name: "admin.module.access")]
    }
    
    func apiAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [UserTokenModel.authenticator(), UserModel.guardMiddleware()]
    }
    
    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "User",
            "icon": "user",
            "permission": "user.module.access",
            "items": LeafData.array([
                [
                    "url": "/admin/user/users/",
                    "label": "Users",
                    "permission": "user.users.list",
                ],
                [
                    "url": "/admin/user/roles/",
                    "label": "Roles",
                    "permission": "user.roles.list",
                ],
                [
                    "url": "/admin/user/permissions/",
                    "label": "Permissions",
                    "permission": "user.permissions.list",
                ],
            ])
        ]
    }

    func leafPermissionHook(args: HookArguments) -> Bool {
        let req = args["req"] as! Request
        let name = args["key"] as! String

        guard let user = req.auth.get(UserModel.self) else {
            return false
        }
        /// root can do anything
        if user.root {
            return true
        }
        /// if the permission is authenticated we allow the action
        if name == "authenticated" {
            return true
        }
        return user.permissions.contains(name)
    }

    func accessHook(args: HookArguments) -> EventLoopFuture<Bool> {
        let req = args["req"] as! Request
        let name = args["key"] as! String

        guard let user = req.auth.get(UserModel.self) else {
            return req.eventLoop.future(false)
        }
        if user.root {
            return req.eventLoop.future(true)
        }
        if name == "authenticated" {
            return req.eventLoop.future(true)
        }
        return req.eventLoop.future(user.permissions.contains(name))
    }

//    func systemVariablesAccessHook(args: HookArguments) -> EventLoopFuture<Bool> {
//        let req = args["req"] as! Request
//        return req.eventLoop.future(true)
//    }
}
