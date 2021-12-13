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
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)

        app.hooks.register(.adminApiMiddlewares, use: adminApiMiddlewaresHook)
        
        app.hooks.register(.permission, use: webMiddlewaresHook)
        app.hooks.register(.access, use: webMiddlewaresHook)
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminApiRoutes, use: router.adminApiRoutesHook)
        
//        app.hooks.register("form-fields", use: formFieldsHook)
        
        try router.boot(app)
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
