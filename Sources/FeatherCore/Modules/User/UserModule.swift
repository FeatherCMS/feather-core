//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor

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
        app.hooks.register(.installUserAccounts, use: installUserAccountsHook)
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
        try await roles.map { UserRoleModel(key: $0.key, name: $0.name, notes: $0.notes) }.create(on: args.req.db)
        

        let permissions: [User.Permission.Create] = args.req.invokeAllFlat(.installUserPermissions)
        try await permissions.map { UserPermissionModel(namespace: $0.namespace,
                                                         context: $0.context,
                                                         action: $0.action,
                                                         name: $0.name,
                                                         notes: $0.notes) }.create(on: args.req.db)
        
        let accounts: [User.Account.Create] = args.req.invokeAllFlat(.installUserAccounts)
        try await accounts.map { UserAccountModel(email: $0.email,
                                                   password: try Bcrypt.hash($0.password),
                                                   isRoot: $0.isRoot) }.create(on: args.req.db)

    }

    func installUserRolesHook(args: HookArguments) -> [User.Role.Create] {
        [
            .init(key: "editors", name: "Editors", notes: "Editor user role"),
        ]
    }

    func installUserAccountsHook(args: HookArguments) -> [User.Account.Create] {
        [
//            .init(email: "root@feathercms.com", password: "FeatherCMS", isRoot: true),
//            .init(email: "user@feathercms.com", password: "FeatherCMS"),
        ]
    }
    
    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        var permissions = User.availablePermissions()
        permissions += User.Account.availablePermissions()
        permissions += User.Permission.availablePermissions()
        permissions += User.Role.availablePermissions()
        return permissions.map { .init($0) }
    }

//    func formFieldsHook(args: HookArguments) async throws -> [FormComponent] {
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
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            FeatherAccount.redirectMiddleware(path: Feather.config.paths.adminLogin),
        ]
    }
    
    func apiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        var middlewares: [Middleware] = [
            UserAccountTokenAuthenticator(),
        ]
        if !Feather.disableApiSessionAuthMiddleware {
            middlewares.append(UserAccountSessionAuthenticator())
        }
        return middlewares + [FeatherAccount.guardMiddleware()]
    }
    
    func permissionHook(args: HookArguments) -> Bool {
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
    
    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        if args.req.checkPermission(User.permission(for: .detail)) {
            return [
                UserDetailsAdminWidgetTemplate(),
                UserAdminWidgetTemplate(),
            ]
        }
        return []
    }
}
