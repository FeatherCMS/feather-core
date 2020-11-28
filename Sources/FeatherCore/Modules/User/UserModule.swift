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

    var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
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
        
        app.hooks.register("admin", use: (router as! UserRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        app.hooks.register("installer", use: installerHook)

        app.hooks.register("admin-auth-middlewares", use: adminAuthMiddlewaresHook)
        app.hooks.register("api-auth-middlewares", use: apiAuthMiddlewaresHook)
    }
    
    // MARK: - hook functions

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "User",
            "icon": "user",
            "items": LeafData.array([
                [
                    "url": "/admin/user/users/",
                    "label": "Users",
                ],
            ])
        ]
    }

    func installerHook(args: HookArguments) -> ViperInstaller {
        UserInstaller()
    }
    
    func adminAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [UserModel.redirectMiddleware(path: "/login")]
    }
    
    func apiAuthMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [UserTokenModel.authenticator(), UserModel.guardMiddleware()]
    }
}
