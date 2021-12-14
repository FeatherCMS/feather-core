//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension HookName {
    static let installCommonVariables: HookName = "install-common-variables"
}


struct CommonModule: FeatherModule {
    
    let router = CommonRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(CommonMigrations.v1())
        
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register(.install, use: installHook)
        
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        
        app.hooks.register(.installCommonVariables, use: installCommonVariablesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        
        try router.boot(app)
    }
    
    func installHook(args: HookArguments) async {
        let pages: [CommonVariable.Create] = await args.req.invokeAllFlat(.installCommonVariables)
        let objects = pages.map { CommonVariableModel(key: $0.key, name: $0.name, value: $0.value, notes: $0.notes) }
        try! await objects.create(on: args.req.db)
    }
    
    func installUserPermissionsHook(args: HookArguments) async -> [UserPermission.Create] {
        var permissions: [UserPermission.Create] = []
        permissions += CommonVariableModel.userPermissions()
        return permissions
    }
    
    func installCommonVariablesHook(args: HookArguments) async -> [CommonVariable.Create] {
        [
            // MARK: - not found
            
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
            
            // MARK: - empty list
            
            .init(key: "emptyListIcon",
                  name: "Empty list icon",
                  value: "🔍",
                  notes: "Icon for the empty list results view."),
        
            .init(key: "emptyListTitle",
                  name: "Empty list title",
                  value: "Empty list",
                  notes: "Title for the empty list results view."),
        
            .init(key: "emptyListDescription",
                  name: "Empty list description",
                  value: "Unfortunately there are no results.",
                  notes: "Description of the empty list box"),
        
            .init(key: "emptyListLinkLabel",
                  name: "Empty list link label",
                  value: "Try again from scratch →",
                  notes: "Start over link text for the empty list box"),
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
    
    func adminWidgetsHook(args: HookArguments) async -> [TemplateRepresentable] {
        [
            CommonAdminWidgetTemplate()
        ]
    }
}
