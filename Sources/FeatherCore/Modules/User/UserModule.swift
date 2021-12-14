//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor
import Fluent

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

        /// register session related stuff
        app.sessions.use(.fluent)
        app.migrations.add(SessionRecord.migration)
        app.middleware.use(app.sessions.middleware)

        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register(.install, use: installHook)
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)

        app.hooks.register(.adminApiMiddlewares, use: adminApiMiddlewaresHook)
        
        app.hooks.register(.permission, use: webMiddlewaresHook)
        app.hooks.register(.access, use: webMiddlewaresHook)
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminApiRoutes, use: router.adminApiRoutesHook)
        
        app.hooks.register(.installUserRoles, use: installUserRolesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        app.hooks.register(.installUserAccounts, use: installUserAccountsHook)
        
//        app.hooks.register("form-fields", use: formFieldsHook)
        
        try router.boot(app)
    }
    
    func installHook(args: HookArguments) async {
        let roles: [UserRole.Create] = await args.req.invokeAllFlat(.installUserRoles)
        try! await roles.map { UserRoleModel(key: $0.key, name: $0.name, notes: $0.notes) }.create(on: args.req.db)

        let permissions: [UserPermission.Create] = await args.req.invokeAllFlat(.installUserPermissions)
        try! await permissions.map { UserPermissionModel(namespace: $0.namespace,
                                                         context: $0.context,
                                                         action: $0.action,
                                                         name: $0.name,
                                                         notes: $0.notes) }.create(on: args.req.db)
        
        let accounts: [UserAccount.Create] = await args.req.invokeAllFlat(.installUserAccounts)
        try! await accounts.map { UserAccountModel(email: $0.email,
                                                   password: try! Bcrypt.hash($0.password)) }.create(on: args.req.db)

    }

    func installUserRolesHook(args: HookArguments) async -> [UserRole.Create] {
        [
            .init(key: "editors", name: "Editors", notes: "Editor user role"),
        ]
    }
    
    func installUserAccountsHook(args: HookArguments) async -> [UserAccount.Create] {
        [
            .init(email: "root@feathercms.com", password: "FeatherCMS", root: true),
            .init(email: "user@feathercms.com", password: "FeatherCMS"),
        ]
    }
    
    func installUserPermissionsHook(args: HookArguments) async -> [UserPermission.Create] {
        var permissions: [UserPermission.Create] = []
        permissions += UserAccountModel.userPermissions()
        permissions += UserPermissionModel.userPermissions()
        permissions += UserRoleModel.userPermissions()
        return permissions
    }

//    func formFieldsHook(args: HookArguments) async -> [FormComponent] {
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
            FeatherUser.redirectMiddleware(path: Feather.config.paths.adminLogin),
        ]
    }
    
    func adminApiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        var middlewares = [
            UserTokenModel.authenticator(),
            FeatherUser.guardMiddleware(),
        ]
//        if !Feather.disableApiSessionAuthMiddleware {
            middlewares.append(UserAccountSessionAuthenticator())
//        }
        return middlewares
    }
    
    func permissionHook(args: HookArguments) -> Bool {
        guard let user = args.req.auth.get(FeatherUser.self) else {
            return false
        }
        if user.isRoot {
            return true
        }
        return user.permissions.contains(args.permission)
    }

    func accessHook(args: HookArguments) async -> Bool {
        permissionHook(args: args)
    }
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            UserDetailsAdminWidgetTemplate(args.req),
            UserAdminWidgetTemplate(args.req),
        ]
    }
}
