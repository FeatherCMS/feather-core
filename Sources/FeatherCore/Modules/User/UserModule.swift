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
        Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Bundles")
            .appendingPathComponent("User")
    }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(UserModelContentMiddleware())
        
        app.hooks.register("admin", use: (router as! UserRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        app.hooks.register("installer", use: installerHook)

        app.hooks.register("admin-auth-middlwares", use: adminAuthMiddlewaresHook)
        app.hooks.register("api-auth-middlwares", use: apiAuthMiddlewaresHook)
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
