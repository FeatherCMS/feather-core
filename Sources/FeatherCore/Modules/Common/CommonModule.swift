//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class CommonModule: FeatherModule {

    static var moduleKey: String = "common"

    var bundleUrl: URL? {
        Self.moduleBundleUrl
    }

    func boot(_ app: Application) throws {
        /// database
        app.migrations.add(CommonMigration_v1())
        /// middlewares
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        /// install
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        /// acl
        //app.hooks.register("system-variables-list-access", use: systemVariablesAccessHook)
        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// routes
        try CommonRouter().bootAndregisterHooks(app)
    }
  
    // MARK: - hooks

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            CommonTemplateScopeMiddleware(),
        ]
    }

    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "common",
              item: .init(icon: "box", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: CommonVariableModel.adminLink, permission: CommonVariableModel.permission(for: .list).identifier),
                .init(link: .init(label: "Files", url: "/admin/common/files/"), permission: nil),
              ])
    }

//    func systemVariablesAccessHook(args: HookArguments) -> EventLoopFuture<Bool> {
//        let req = args.req
//        return req.eventLoop.future(true)
//    }
    
/*
     Translation experiment:

     #("foo".t())
     
     app.hooks.register("translation", use: test)

     func test(args: HookArguments) -> [String: String] {
        [
            "foo": "bar"
        ]
     }
 */
        
    
}
