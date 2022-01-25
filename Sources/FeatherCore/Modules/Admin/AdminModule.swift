//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//



public extension HookName {
    static let adminRoutes: HookName = "admin-routes"
    static let adminMiddlewares: HookName = "admin-middlewares"
    static let adminWidgets: HookName = "admin-widgets"
    
    static let adminCss: HookName = "admin-css"
    static let adminJs: HookName = "admin-js"
}

struct AdminModule: FeatherModule {
    
    let router = AdminRouter()
    
    func boot(_ app: Application) throws {
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.webRoutes, use: router.webRoutesHook)
        
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        
        try router.boot(app)
    }
    
    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        let permissions = Admin.availablePermissions()
        return permissions.map { .init($0) }
    }    
}
