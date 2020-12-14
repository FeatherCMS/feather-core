//
//  FrontendModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

final class FrontendModule: ViperModule {

    static let name = "frontend"
    var priority: Int { 2000 }
    
    var router: ViperRouter? = FrontendRouter()
    
    var migrations: [Migration] {
        [
            FrontendMigration_v1_0_0()
        ]
    }

    static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Modules")
            .appendingPathComponent(name.capitalized)
    }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataModelMiddleware<FrontendPageModel>())

        /// install
        app.hooks.register("model-install", use: modelInstallHook)
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
        app.hooks.register("system-variables-install", use: systemVariablesInstallHook)
        
        /// admin
        app.hooks.register("admin", use: (router as! FrontendRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        
        /// cache
        app.hooks.register("prepare-request-cache", use: prepareRequestCacheHook)
        
        app.hooks.register("routes", use: (router as! FrontendRouter).routesHook)
        
        app.hooks.register("frontend-page", use: frontendPageHook)
        app.hooks.register("frontend-home-page", use: frontendHomePageHook)
    }

    func leafDataGenerator(for req: Request) -> [String: LeafDataGenerator]? {
        let menus = req.cache["frontend.menus"] as? [String: LeafDataRepresentable] ?? [:]
        return [
            "menus": .lazy(LeafData.dictionary(menus))
        ]
    }

    // MARK: - hooks

    func prepareRequestCacheHook(args: HookArguments) -> EventLoopFuture<[String: Any?]> {
        let req = args["req"] as! Request
        return FrontendMenuModel.query(on: req.db).with(\.$items).all().map { menus in
            var items: [String: LeafDataRepresentable] = [:]
            for menu in menus {
                items[menu.key] = menu.leafData
            }
            return items
        }
        .map { items in
             ["frontend.menus": items as Any?]
        }
    }
    
    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Frontend",
            "icon": "layout",
            "permission": "frontend",
            "items": LeafData.array([
                [
                    "label": "Pages",
                    "url": "/admin/frontend/pages/",
                ],
                [
                    "url": "/admin/frontend/menus/",
                    "label": "Menus",
                    "permission": "frontend.menus.list",
                ],
                [
                    "url": "/admin/frontend/settings/",
                    "label": "Settings",
                    "permission": "frontend.settings",
                ],
                
            ])
        ]
    }
    
    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return FrontendPageModel.queryPublicMetadata(path: req.url.path, on: req.db)
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
                var ctx = page.leafDataWithJoinedMetadata.dictionary!
                ctx["content"] = .string(page.filter(content, req: req))
                return req.leaf.render(template: "Frontend/Page", context: .init(ctx)).encodeOptionalResponse(for: req)
            }
    }
    
    /// renders the [frontend-home-page] content
    func frontendHomePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata

        return req.leaf.render(template: "Frontend/Home", context: [
            "metadata": metadata.leafData,
        ])
        .encodeOptionalResponse(for: req)
    }

}

