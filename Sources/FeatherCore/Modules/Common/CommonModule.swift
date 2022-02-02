//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

public extension HookName {
    static let installCommonVariables: HookName = "install-common-variables"
}


struct CommonModule: FeatherModule {
    
    let router = CommonRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(CommonMigrations.v1())

        app.hooks.register(.installCommonVariables, use: installCommonVariablesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)

        app.hooks.registerAsync(.install, use: installHook)

        try router.boot(app)
    }
    
    func installHook(args: HookArguments) async throws {
        let pages: [Common.Variable.Create] = args.req.invokeAllFlat(.installCommonVariables)
        let objects = pages.map { CommonVariableModel(key: $0.key, name: $0.name, value: $0.value, notes: $0.notes) }
        try await objects.create(on: args.req.db)
    }
    
    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        var permissions = Common.availablePermissions()
        permissions += Common.Variable.availablePermissions()
        return permissions.map { .init($0) }
    }
    
    func installCommonVariablesHook(args: HookArguments) -> [Common.Variable.Create] {
        [
            .init(key: "pageNotFoundIcon",
                  name: "Page not found icon",
                  value:  "🙉",
                  notes: "Icon for the not found page"),
            
            .init(key: "pageNotFoundTitle",
                  name: "Page not found title",
                  value: "Page not found",
                  notes: "Title of the not found page"),
        
            .init(key: "pageNotFoundExcerpt",
                  name: "Page not found excerpt",
                  value: "Unfortunately the requested page is not available.",
                  notes: "Excerpt for the not found page"),
        
            .init(key: "pageNotFoundLinkLabel",
                  name: "Page not found link label",
                  value: "Go to the home page →",
                  notes: "Retry link text for the not found page"),
        
            .init(key: "pageNotFoundLinkUrl",
                  name: "Page not found link URL",
                  value: "/",
                  notes: "Retry link URL for the not found page"),
        ]
    }
    
    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            CommonVariablesMiddleware(),
        ]
    }
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            CommonVariablesMiddleware(),
        ]
    }
    
    func adminWidgetsHook(args: HookArguments) -> [OrderedHookResult<TemplateRepresentable>] {
        if args.req.checkPermission(Common.permission(for: .detail)) {
            return [
                .init(CommonAdminWidgetTemplate(), order: 100),
            ]
        }
        return []
    }
}
