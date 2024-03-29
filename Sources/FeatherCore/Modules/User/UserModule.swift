//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import FeatherCoreApi

extension FeatherToken: Content {}
extension FeatherAccount: Content {}
extension FeatherRole: Content {}
extension FeatherPermission: Content {}

extension FeatherAccount: SessionAuthenticatable {
    public typealias SessionID = UUID

    public var sessionID: SessionID { id }
}


public extension User.Account {
    
    static func queryOptions(_ req: Request) async throws -> [OptionContext] {
        try await UserAccountModel.query(on: req.db).all().map {
            .init(key: $0.uuid.string, label: $0.email)
        }
    }
}

public extension HookName {

    static let permission: HookName = "permission"
    static let access: HookName = "access"
    
    static let installUserRoles: HookName = "install-user-roles"
    static let installUserPermissions: HookName = "install-user-permissions"
    static let installUserAccounts: HookName = "install-user-accounts"
    
    static let installUserRolePermissions: HookName = "install-user-role-permissions"
    static let installUserAccountRoles: HookName = "install-user-account-roles"
}


struct UserModule: FeatherModule {
    let router = UserRouter()

    func boot(_ app: Application) throws {
        app.migrations.add(UserMigrations.v1())
        app.databases.middleware.use(UserAccountModelMiddleware())

        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        app.hooks.register(.apiMiddlewares, use: apiMiddlewaresHook)
        app.hooks.register(.permission, use: permissionHook)
        app.hooks.register(.webRoutes, use: router.webRoutesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.publicApiRoutes, use: router.publicApiRoutesHook)
        app.hooks.register(.installUserRoles, use: installUserRolesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        app.hooks.register(.installStep, use: installStepHook)

        app.hooks.registerAsync(.install, use: installHook)
        app.hooks.registerAsync(.installResponse, use: installResponseHook)
        app.hooks.registerAsync(.access, use: accessHook)

//        app.hooks.register("form-fields", use: formFieldsHook)
        
        try router.boot(app)
    }
    
    // MARK: - install
    
    func installStepHook(args: HookArguments) -> [SystemInstallStep] {
        [
            .init(key: Self.featherIdentifier, priority: 9000),
        ]
    }
    
    func installResponseHook(args: HookArguments) async throws -> Response? {
        guard args.installInfo.currentStep == Self.featherIdentifier else {
            return nil
        }
        return try await UserInstallStepController().handleInstallStep(args.req, info: args.installInfo)
    }
    
    
    func installHook(args: HookArguments) async throws {
        let roles: [User.Role.Create] = args.req.invokeAllFlat(.installUserRoles)
        try await roles.map { UserRoleModel(key: $0.key, name: $0.name, notes: $0.notes) }.create(on: args.req.db, chunks: 25)
        

        let permissions: [User.Permission.Create] = args.req.invokeAllFlat(.installUserPermissions)
        try await permissions.map { UserPermissionModel(namespace: $0.namespace,
                                                         context: $0.context,
                                                         action: $0.action,
                                                         name: $0.name,
                                                         notes: $0.notes) }.create(on: args.req.db, chunks: 25)
        
        let accounts: [User.Account.Create] = args.req.invokeAllFlat(.installUserAccounts)
        try await accounts.map { UserAccountModel(email: $0.email,
                                                   password: try Bcrypt.hash($0.password),
                                                   isRoot: $0.isRoot) }.create(on: args.req.db, chunks: 25)
        
        
        let rolePermissions: [User.RolePermission.Create] = args.req.invokeAllFlat(.installUserRolePermissions)
        for rolePermission in rolePermissions {
            guard
                let role = try await UserRoleModel
                    .query(on: args.req.db)
                    .filter(\.$key == rolePermission.key)
                    .first()
            else {
                continue
            }
            for permission in rolePermission.permissionKeys {
                let p = FeatherPermission(permission)
                guard
                    let permission = try await UserPermissionModel
                        .query(on: args.req.db)
                        .filter(\.$namespace == p.namespace)
                        .filter(\.$context == p.context)
                        .filter(\.$action == p.action.key)
                        .first()
                else {
                    continue
                }
                let rpm = UserRolePermissionModel(roleId: role.uuid, permissionId: permission.uuid)
                try await rpm.create(on: args.req.db)
            }
        }
        
        let accountRoles: [User.AccountRole.Create] = args.req.invokeAllFlat(.installUserAccountRoles)
        for accountRole in accountRoles {
            guard
                let account = try await UserAccountModel
                    .query(on: args.req.db)
                    .filter(\.$email == accountRole.email)
                    .first()
            else {
                continue
            }
            for roleKey in accountRole.roleKeys {
                guard
                    let role = try await UserRoleModel
                        .query(on: args.req.db)
                        .filter(\.$key == roleKey)
                        .first()
                else {
                    continue
                }
                let arm = UserAccountRoleModel(accountId: account.uuid, roleId: role.uuid)
                try await arm.create(on: args.req.db)
            }
        }
    }

    func installUserRolesHook(args: HookArguments) -> [User.Role.Create] {
        [
            .init(key: "editors", name: "Editors", notes: "Editor user role"),
        ]
    }

    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        var permissions = User.availablePermissions()
        permissions += User.Account.availablePermissions()
        permissions += User.Permission.availablePermissions()
        permissions += User.Role.availablePermissions()
        permissions += [
            .init(namespace: "user", context: "account", action: .custom("login")),
            .init(namespace: "user", context: "account", action: .custom("logout")),
        ]
        return permissions.map { .init($0) }
    }
    

//    func formFieldsHook(args: HookArguments) async throws -> [FormField] {
//        return [
//            InputField("lorem")
//                .validators {
//                    FormFieldValidator.required($1)
//                }
//                .read { $1.output.context.value = model.key }
//                .write { model.key = $1.input }
//        ]
//    }
    
    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator()
        ]
    }
    
    private func adminLogin(_ feather: Feather) -> String {
        "/\(feather.config.paths.login)/?\(feather.config.paths.redirectQueryKey)=/\(feather.config.paths.admin)/"
    }

    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            FeatherAccount.redirectMiddleware(path: adminLogin(args.app.feather)),
        ]
    }
    
    func apiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        var middlewares: [Middleware] = [
            UserAccountTokenAuthenticator(),
        ]
        if !args.app.feather.disableApiSessionAuthMiddleware {
            middlewares.append(UserAccountSessionAuthenticator())
        }
        return middlewares + [FeatherAccount.guardMiddleware()]
    }
    
    func permissionHook(args: HookArguments) -> Bool {
        if args.permission.key == "user.account.login" {
            return !args.req.auth.has(FeatherAccount.self)
        }
        if args.permission.key == "user.account.logout" {
            return args.req.auth.has(FeatherAccount.self)
        }
        guard let user = args.req.auth.get(FeatherAccount.self) else {
            return false
        }
        if user.isRoot {
            return true
        }
        return user.hasPermission(args.permission)
    }

    func accessHook(args: HookArguments) async throws -> Bool {
        permissionHook(args: args)
    }
    
    func adminWidgetsHook(args: HookArguments) -> [OrderedHookResult<TemplateRepresentable>] {
        if args.req.checkPermission(User.permission(for: .detail)) {
            return [
                .init(UserAdminWidgetTemplate(), order: 800),
            ]
        }
        return []
    }
}
