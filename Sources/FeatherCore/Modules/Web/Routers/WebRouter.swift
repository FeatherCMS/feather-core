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
        app.routes.get(Feather.config.paths.sitemap.pathComponent, use: frontendController.renderSitemapTemplate)
        app.routes.get(Feather.config.paths.rss.pathComponent, use: frontendController.renderRssTemplate)
        app.routes.get(Feather.config.paths.robots.pathComponent, use: frontendController.renderRobotsTemplate)
    }

    func routesHook(args: HookArguments) {
        
    }
    
    func adminRoutesHook(args: HookArguments) {
        metadataAdminController.setupListRoutes(args.routes)
        metadataAdminController.setupDetailRoutes(args.routes)
        metadataAdminController.setupUpdateRoutes(args.routes)
        pageAdminController.setupRoutes(args.routes)
        menuAdminController.setupRoutes(args.routes)
        menuItemAdminController.setupRoutes(args.routes)
        
        args.routes.grouped("web").get("settings", use: settingsAdminController.settingsView)
        args.routes.grouped("web").post("settings", use: settingsAdminController.settings)
        
        args.routes.get("web") { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Web", message: "module information", links: [
                .init(label: "Menus", path: "/admin/web/menus/"),
                .init(label: "Pages", path: "/admin/web/pages/"),
                .init(label: "Metadatas", path: "/admin/web/metadatas/"),
                .init(label: "Settings", path: "/admin/web/settings/"),
            ]))
            return req.templates.renderHtml(template)
        }
    }

    func apiRoutesHook(args: HookArguments) {
        metadataApiController.setupListRoutes(args.routes)
        metadataApiController.setupDetailRoutes(args.routes)
        metadataApiController.setupUpdateRoutes(args.routes)
        pageApiController.setupRoutes(args.routes)
        menuApiController.setupRoutes(args.routes)
        menuItemApiController.setupRoutes(args.routes)
    }
}
