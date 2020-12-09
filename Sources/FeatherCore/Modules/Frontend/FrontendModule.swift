//
//  FrontendModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

public final class FrontendModule: ViperModule {

    public static let name = "frontend"
    public var priority: Int { 2000 }
    
    public var router: ViperRouter? = FrontendRouter()
    
    public var migrations: [Migration] {
        [
            FrontendMigration_v1_0_0()
        ]
    }

    public static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Modules")
            .appendingPathComponent(name.capitalized)
    }

    public func boot(_ app: Application) throws {
        app.databases.middleware.use(FrontendMetadataMiddleware<FrontendPageModel>())

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

    public func leafDataGenerator(for req: Request) -> [String: LeafDataGenerator]? {
        let menus = req.cache["frontend.menus"] as? [String: LeafDataRepresentable] ?? [:]
        return [
            "menus": .lazy(LeafData.dictionary(menus))
        ]
    }

    // MARK: - hooks

    func modelInstallHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args["req"] as! Request
        let mainId = UUID()
        let mainMenu = FrontendMenuModel(id: mainId, key: "main", name: "Main menu")

        /// gather the main menu items through a hook function then map them
        let menuItems: [[[String: Any]]] = req.invokeAll("frontend-main-menu-install")
        var mainMenuItemModels = menuItems.flatMap { $0 }.compactMap { item -> FrontendMenuItemModel? in
            guard
                let label = item["label"] as? String, !label.isEmpty,
                let url = item["url"] as? String, !url.isEmpty
            else {
                return nil
            }
            let icon = item["icon"] as? String
            let targetBlank = item["targetBlank"] as? Bool ?? false
            let priority = item["priority"] as? Int ?? 100

            return FrontendMenuItemModel(icon: icon, label: label, url: url, priority: priority, targetBlank: targetBlank, menuId: mainId)
        }

        /// we add a home menu item as well with a relatively high priority
        let homeMenuItem = FrontendMenuItemModel(label: "Home", url: "/", priority: 1000, menuId: mainId)
        mainMenuItemModels.insert(homeMenuItem, at: 0)

        /// we add an about menu item
        let aboutMenuItem = FrontendMenuItemModel(label: "About", url: "/about/", priority: 0, menuId: mainId)
        mainMenuItemModels.insert(aboutMenuItem, at: 0)

        let footerId = UUID()
        let footerMenu = FrontendMenuModel(id: footerId, key: "footer", name: "Footer menu")

        let footerItems = [
            FrontendMenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, targetBlank: true, menuId: footerId),
            FrontendMenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, targetBlank: true, menuId: footerId),
        ]

        /// we expect a key-value array of static page install elements with title and content keys
        let pages: [[[String: Any]]] = req.invokeAll("frontend-page-install")
        var pageModels = pages.flatMap({ $0 }).compactMap { page -> FrontendPageModel? in
            guard
                let title = page["title"] as? String, !title.isEmpty,
                let content = page["content"] as? String, !content.isEmpty
            else {
                return nil
            }
            return FrontendPageModel(title: title, content: content)
        }

        /// create home page with a hookable page content
        let homePage = FrontendPageModel(title: "Home", content: "[frontend-home-page]")

        /// create a sample about page
        let aboutPage = FrontendPageModel(title: "About", content: FrontendModule.sample(asset: "about.html"))
        pageModels.append(aboutPage)

        /// we persist the pages to the database
        return req.eventLoop.flatten([
            /// save home page and set it as a published root page by altering the metadata
            homePage.create(on: req.db).flatMap { homePage.updateMetadata(on: req.db, { $0.slug = ""; $0.status = .published }) },
            /// save pages, then we publish the associated metadatas
            pageModels.create(on: req.db).flatMap { _ in
                req.eventLoop.flatten(pageModels.map { $0.publishMetadata(on: req.db) })
            },
            /// finally create menu items
            [mainMenu, footerMenu].create(on: req.db).flatMap {
                (mainMenuItemModels + footerItems).create(on: req.db)
            }
        ])
    }

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
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            /// frontend
            ["key": "frontend",                     "name": "Frontend module"],
            ["key": "frontend.settings",            "name": "Frontend settings"],
            
            /// metadatas
            ["key": "frontend.metadatas.list",      "name": "Frontend metadata list"],
            ["key": "frontend.metadatas.create",    "name": "Frontend metadata create"],
            ["key": "frontend.metadatas.update",    "name": "Frontend metadata update"],
            ["key": "frontend.metadatas.delete",    "name": "Frontend metadata delete"],
            
            /// menus
            ["key": "frontend.menus.list",          "name": "Menu list"],
            ["key": "frontend.menus.create",        "name": "Menu create"],
            ["key": "frontend.menus.update",        "name": "Menu update"],
            ["key": "frontend.menus.delete",        "name": "Menu delete"],

            /// menu items
            ["key": "frontend.menu.items.list",     "name": "Menu item list"],
            ["key": "frontend.menu.items.create",   "name": "Menu item create"],
            ["key": "frontend.menu.items.update",   "name": "Menu item update"],
            ["key": "frontend.menu.items.delete",   "name": "Menu item delete"],
        ]
    }

    func systemVariablesInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            [
                "key": "frontend.site.logo",
                "name": "Site logo",
                "note": "Logo of the website",
            ],
            [
                "key": "frontend.site.title",
                "name": "Site title",
                "value": "Feather",
                "note": "Title of the website",
            ],
            [
                "key": "frontend.site.excerpt",
                "name": "Site excerpt",
                "value": "Feather is an open-source CMS written in Swift using Vapor 4.",
                "note": "Description of the website",
            ],
            [
                "key": "frontend.site.color.primary",
                "name": "Site color - primary",
                "note": "Primary color of the website",
            ],
            [
                "key": "frontend.site.color.secondary",
                "name": "Site color - secondary",
                "note": "Secondary color of the website",
            ],
            [
                "key": "frontend.site.font.family",
                "name": "Site font family",
                "note": "Custom font family for the site",
            ],
            [
                "key": "frontend.site.font.size",
                "name": "Site font size",
                "note": "Custom font size for the site",
            ],
            [
                "key": "frontend.site.css",
                "name": "Site CSS",
                "note": "Global CSS injection for the site",
            ],
            [
                "key": "frontend.site.js",
                "name": "Site JS",
                "note": "Global JavaScript injection for the site",
            ],
            [
                "key": "frontend.site.footer",
                "name": "Site footer",
                "value": "<img class=\"s64\" src=\"/images/icons/icon.png\" alt=\"Logo of Feather\" title=\"Feather\">",
                "note": "Custom contents for the footer",
            ],
            [
                "key": "frontend.site.copy",
                "name": "Site copy",
                "value": "This site is powered by <a href=\"https://feathercms.com/\" target=\"_blank\">Feather CMS</a>",
                "note": "Copyright text for the website",
            ],
            [
                "key": "frontend.site.copy.start.year",
                "name": "Site copy start year",
                "note": "Start year placed before the current one in the copy line",
            ],
            [
                "key": "frontend.site.footer.bottom",
                "name": "Site footer bottom",
                "note": "Bottom footer content placed under the footer menu",
            ],
            [
                "key": "frontend.home.page.title",
                "name": "Home page title",
                "value": "Welcome",
                "note": "Title of the home page",
            ],
            [
                "key": "frontend.home.page.description",
                "name": "Home page description",
                "value": "This is your brand new Feather CMS powered website",
                "note": "Description of the home page",
            ],
            [
                "key": "frontend.home.page.icon",
                "name": "Home page icon",
                "value": "🪶",
                "note": "Icon of the home page",
            ],
            [
                "key": "frontend.home.page.link.label",
                "name": "Home page link label",
                "value": "Start customizing →",
                "note": "Link label of the home page",
            ],
            [
                "key": "frontend.home.page.link.url",
                "name": "Home page link url",
                "value": "/admin/",
                "note": "Link URL of the home page",
            ],
            [
                "key": "frontend.page.not.found.icon",
                "name": "Page not found icon",
                "value": "🙉",
                "note": "Icon for the not found page",
            ],
            [
                "key": "frontend.page.not.found.title",
                "name": "Page not found title",
                "value": "Page not found",
                "note": "Title of the not found page",
            ],
            [
                "key": "frontend.page.not.found.description",
                "name": "Page not found description",
                "value": "Unfortunately the requested page is not available.",
                "note": "Description of the not found page",
            ],
            [
                "key": "frontend.page.not.found.link",
                "name": "Page not found link",
                "value": "Go to the home page →",
                "note": "Retry link text for the not found page",
            ],
        ]
    }
    
    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return FrontendMetadata.query(on: req.db)
            .filter(FrontendMetadata.self, \.$module == FrontendModule.name)
            .filter(FrontendMetadata.self, \.$model == FrontendPageModel.name)
            .filter(FrontendMetadata.self, \.$slug == req.url.path.trimmingSlashes())
            .filter(FrontendMetadata.self, \.$status != .archived)
            .first()
            .flatMap { metadata -> EventLoopFuture<Response?> in
                guard let metadata = metadata else {
                    return req.eventLoop.future(nil)
                }
                return FrontendPageModel
                    .find(metadata.reference, on: req.db)
                    .flatMap { page in
                        guard let page = page else {
                            return req.eventLoop.future(nil)
                        }
                        let content = page.content.trimmingCharacters(in: .whitespacesAndNewlines)
                        if content.hasPrefix("["), content.hasSuffix("]") {
                            let name = String(content.dropFirst().dropLast())
                            let args = ["page-metadata": metadata]
                            if let future: EventLoopFuture<Response?> = req.invoke(name, args: args) {
                                return future
                            }
                        }
                        return req.leaf.render(template: "Frontend/Page", context: [
                            "page": .dictionary([
                                "title": page.title,
                                "content": metadata.filter(content, req: req),
                            ]),
                            "metadata": metadata.leafData,
                        ])
                        .encodeOptionalResponse(for: req)
                    }
            }
    }
    
    /// renders the [frontend-home-page] content
    func frontendHomePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! FrontendMetadata

        return req.leaf.render(template: "Frontend/Home", context: [
            "metadata": metadata.leafData,
        ])
        .encodeOptionalResponse(for: req)
    }

}

