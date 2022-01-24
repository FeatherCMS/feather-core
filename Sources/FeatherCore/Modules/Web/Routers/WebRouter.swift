//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct WebRouter: FeatherRouter {
    
    let metadataAdminController = WebMetadataAdminController()
    let metadataApiController = WebMetadataApiController()
    let pageAdminController = WebPageAdminController()
    let pageApiController = WebPageApiController()
    let menuAdminController = WebMenuAdminController()
    let menuApiController = WebMenuApiController()
    let menuItemAdminController = WebMenuItemAdminController()
    let menuItemApiController = WebMenuItemApiController()
    let settingsAdminController = WebSettingsAdminController()
    
    func boot(_ app: Application) throws {
        let frontendController = WebFrontendController()
        app.routes.get(app.feather.config.paths.sitemap.pathComponent, use: frontendController.renderSitemapTemplate)
        app.routes.get(app.feather.config.paths.rss.pathComponent, use: frontendController.renderRssTemplate)
        app.routes.get(app.feather.config.paths.robots.pathComponent, use: frontendController.renderRobotsTemplate)
        app.routes.get(app.feather.config.paths.manifest.pathComponent, use: frontendController.webManifestView)
    }

    func routesHook(args: HookArguments) {
        
    }
    
    func adminRoutesHook(args: HookArguments) {
        metadataAdminController.setUpListRoutes(args.routes)
        metadataAdminController.setUpDetailRoutes(args.routes)
        metadataAdminController.setUpUpdateRoutes(args.routes)
        pageAdminController.setUpRoutes(args.routes)
        menuAdminController.setUpRoutes(args.routes)
        menuItemAdminController.setUpRoutes(args.routes)
        
        args.routes.grouped("web").get("settings", use: settingsAdminController.settingsView)
        args.routes.grouped("web").post("settings", use: settingsAdminController.settings)
        
        args.routes.get("web") { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Web",
                                                         message: "module information",
                                                         navigation: [
                                                            .init(label: "Menus", path: "/admin/web/menus/"),
                                                            .init(label: "Pages", path: "/admin/web/pages/"),
                                                            .init(label: "Metadatas", path: "/admin/web/metadatas/"),
                                                            .init(label: "Settings", path: "/admin/web/settings/"),
                                                         ]))
            return req.templates.renderHtml(template)
        }
    }

    func apiRoutesHook(args: HookArguments) {
        metadataApiController.setUpListRoutes(args.routes)
        metadataApiController.setUpDetailRoutes(args.routes)
        metadataApiController.setUpUpdateRoutes(args.routes)
        pageApiController.setUpRoutes(args.routes)
        menuApiController.setUpRoutes(args.routes)
        menuItemApiController.setUpRoutes(args.routes)
    }
}
