//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class FrontendModule: FeatherModule {

    static var moduleKey: String = "frontend"

    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// database
        
        app.databases.middleware.use(MetadataModelMiddleware<FrontendPageModel>())
        app.migrations.add(SystemMigration_v1())
        /// middlewares
        app.middleware.use(SystemTemplateScopeMiddleware())
        app.middleware.use(FrontendSafePathMiddleware())
        

        /// install
        app.hooks.register("install-models", use: installModelsHook)
        app.hooks.register("install-permissions", use: installPermissionsHook)
        app.hooks.register("install-variables", use: installVariablesHook)
        /// admin menus
        app.hooks.register("admin-menus", use: adminMenusHook)
        /// routes
        let router = FrontendRouter()
        try router.boot(routes: app.routes)
        app.hooks.register("routes", use: router.routesHook)
        app.hooks.register("admin-routes", use: router.adminRoutesHook)
        app.hooks.register("api-routes", use: router.apiRoutesHook)
        app.hooks.register("api-admin-routes", use: router.apiAdminRoutesHook)
        /// pages
        app.hooks.register("response", use: responseHook)
        app.hooks.register("home-page", use: homePageHook)
    }
  
    // MARK: - hooks
    
    func responseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        return FrontendPageModel
            .queryJoinVisibleMetadata(path: req.url.path, on: req.db)
            .first()
            .flatMap { page -> EventLoopFuture<Response?> in
                guard let page = page else {
                    return req.eventLoop.future(nil)
                }
                /// if the content of a page has a page tag, then we respond with the corresponding page hook function
                let content = page.content.trimmingCharacters(in: .whitespacesAndNewlines)
                if content.hasPrefix("["), content.hasSuffix("-page]") {
                    let name = String(content.dropFirst().dropLast())
                    let args: HookArguments = ["page-metadata": page.joinedMetadata as Any]
                    if let future: EventLoopFuture<Response?> = req.invoke(name, args: args) {
                        return future
                    }
                }
                /// render the page with the filtered content
                return page.filter(content, req: req).flatMap {
                    var ctx = page.encodeToTemplateData().dictionary!
                    ctx["content"] = .string($0)
                    return req.tau.render(template: "System/Page", context: .init(ctx)).encodeOptionalResponse(for: req)
                }
            }
    }
    
    /// renders the [home-page] content
    func homePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        
        let metadata = args["page-metadata"] as! Metadata

        return req.view.render("System/Home", ["metadata": metadata]).encodeOptionalResponse(for: req)
    }

    #warning("add back permissions")
    func adminMenusHook(args: HookArguments) -> [FrontendMenu] {
        [

            .init(key: "web",
                  link: .init(label: "Frontend",
                              url: "/admin/web/",
                              icon: "web",
                              permission: nil),
                  items: [
                    .init(label: "Pages",
                          url: "/admin/system/pages/",
                          permission: nil),
                    .init(label: "Menus",
                          url: "/admin/system/menus/",
                          permission: nil),
                    .init(label: "Metadatas",
                          url: "/admin/system/metadatas/",
                          permission: nil),
                  ]),
        ]
    }
}
