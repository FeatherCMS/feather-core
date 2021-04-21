//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class CommonModule: FeatherModule {

    static var moduleKey: String = "common"

    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// database
        app.migrations.add(CommonMigration_v1())
        /// middlewares
        app.middleware.use(SystemTemplateScopeMiddleware())
        
        /// install
        app.hooks.register("install-models", use: installModelsHook)
        app.hooks.register("install-permissions", use: installPermissionsHook)
        app.hooks.register("install-variables", use: installVariablesHook)
        /// acl
        //app.hooks.register("system-variables-list-access", use: systemVariablesAccessHook)
        /// admin menus
        app.hooks.register("admin-menus", use: adminMenusHook)
        /// routes
        let router = CommonRouter()
        try router.boot(routes: app.routes)
        app.hooks.register("admin-routes", use: router.adminRoutesHook)
        app.hooks.register("api-routes", use: router.apiRoutesHook)
        app.hooks.register("api-admin-routes", use: router.apiAdminRoutesHook)
    }
  
    // MARK: - hooks
    
   
   

    #warning("add back permissions")
    func adminMenusHook(args: HookArguments) -> [FrontendMenu] {
        [
            .init(key: "common",
                  link: .init(label: "Common",
                              url: "/admin/common/",
                              icon: "system",
                              permission: nil),
                  items: [
                    .init(label: "Variables",
                          url: "/admin/common/variables/",
                          permission: nil),
                    .init(label: "Files",
                          url: "/admin/common/files/",
                          permission: nil),
//                    .init(label: "Labels",
//                          url: "#",
//                          permission: nil),
                  ]),
        ]
    }



//    func systemVariablesAccessHook(args: HookArguments) -> EventLoopFuture<Bool> {
//        let req = args["req"] as! Request
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
