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
        
        args.routes.grouped(Web.pathKey.pathComponent).get("settings", use: settingsAdminController.settingsView)
        args.routes.grouped(Web.pathKey.pathComponent).post("settings", use: settingsAdminController.settings)
        
        args.routes.get(Web.pathKey.pathComponent) { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Web",
                                                         tag: WebAdminWidgetTemplate().render(req)))
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
