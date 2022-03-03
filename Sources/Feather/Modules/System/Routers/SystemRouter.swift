//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

struct SystemRouter: FeatherRouter {

    let responseController = SystemResponseController()

    let adminDashboard = SystemAdminDashboardController()
    let permissionApi = SystemPermissionApiController()
    let permissionAdmin = SystemPermissionAdminController()
    let variableApi = SystemVariableApiController()
    let variableAdmin = SystemVariableAdminController()
    let metadataApi = SystemMetadataApiController()
    let metadataAdmin = SystemMetadataAdminController()
    let settingsAdmin = SystemSettingsAdminController()
    
    func boot(_ app: Application) throws {
        
        app.routes.get(app.feather.config.paths.sitemap.pathComponent, use: responseController.renderSitemapTemplate)
        app.routes.get(app.feather.config.paths.rss.pathComponent, use: responseController.renderRssTemplate)
        app.routes.get(app.feather.config.paths.robots.pathComponent, use: responseController.renderRobotsTemplate)
        app.routes.get(app.feather.config.paths.manifest.pathComponent, use: responseController.renderManifestFile)
    }

    func config(_ app: Application) throws {
        let middlewares: [Middleware] = app.invokeAllFlat(.middlewares)
        let routes = app.routes
            .grouped([SystemInstallGuardMiddleware()])
            .grouped(middlewares)

        var arguments = HookArguments()
        arguments.routes = routes
        let _: [Void] = app.invokeAll(.routes, args: arguments)
    }
    
    func routesHook(args: HookArguments) {
        // MARK: - public api
        
        let publicApiMiddlewares: [Middleware] = args.app.invokeAllFlat(.publicApiMiddlewares)
        let publicApiRoutes = args.routes
            .grouped(args.app.feather.config.paths.api.pathComponent)
            .grouped([SystemApiErrorMiddleware()])
            .grouped(publicApiMiddlewares)
        
        publicApiRoutes.get("status") { _ in "ok" }
        
        var publicApiArguments = HookArguments()
        publicApiArguments.routes = publicApiRoutes
        let _: [Void] = args.app.invokeAll(.publicApiRoutes, args: publicApiArguments)

        // MARK: - api
        
        let apiMiddlewares: [Middleware] = args.app.invokeAllFlat(.apiMiddlewares)
        let apiRoutes = publicApiRoutes
            .grouped(apiMiddlewares)
        
        permissionApi.setUpRoutes(apiRoutes)
        variableApi.setUpRoutes(apiRoutes)
        metadataApi.setUpListRoutes(apiRoutes)
        metadataApi.setUpDetailRoutes(apiRoutes)
        metadataApi.setUpUpdateRoutes(apiRoutes)
        metadataApi.setUpPatchRoutes(apiRoutes)
        
        var apiArguments = HookArguments()
        apiArguments.routes = apiRoutes
        let _: [Void] = args.app.invokeAll(.apiRoutes, args: apiArguments)
        
        // MARK: - web
        
        let webMiddlewares: [Middleware] = args.app.invokeAllFlat(.webMiddlewares)
        let webRoutes = args.routes
            .grouped(webMiddlewares)
            .grouped([
                SystemVariablesMiddleware(),
                SystemErrorMiddleware()
            ])
        
        var webArguments = HookArguments()
        webArguments.routes = webRoutes
        let _: [Void] = args.app.invokeAll(.webRoutes, args: webArguments)
        
        // MARK: - admin
       
        let adminMiddlewares: [Middleware] = args.app.invokeAllFlat(.adminMiddlewares)
        let adminRoutes = args.routes
            .grouped(args.app.feather.config.paths.admin.pathComponent)
            .grouped(adminMiddlewares)
            .grouped([
                AccessRedirectMiddleware(System.permission(for: .detail)),
                SystemAdminErrorMiddleware(),
                SystemVariablesMiddleware()
            ])

        adminRoutes.get(use: adminDashboard.renderDashboardTemplate)
        adminRoutes.get(System.pathKey.pathComponent) { req -> Response in
            let template = SystemAdminModulePageTemplate(.init(title: "System",
                                                               tag: SystemAdminWidgetTemplate().render(req)))
            return req.templates.renderHtml(template)
        }
        
        permissionAdmin.setUpRoutes(adminRoutes)
        variableAdmin.setUpRoutes(adminRoutes)
        metadataAdmin.setUpListRoutes(adminRoutes)
        metadataAdmin.setUpDetailRoutes(adminRoutes)
        metadataAdmin.setUpUpdateRoutes(adminRoutes)
        
        adminRoutes.grouped(System.pathKey.pathComponent).get("settings", use: settingsAdmin.settingsView)
        adminRoutes.grouped(System.pathKey.pathComponent).post("settings", use: settingsAdmin.settings)
        
        
        var adminArguments = HookArguments()
        adminArguments.routes = adminRoutes
        let _: [Void] = args.app.invokeAll(.adminRoutes, args: adminArguments)

        // MARK: - public web
        
        webRoutes.get(use: responseController.handle)
        webRoutes.get(.catchall, use: responseController.handle)
        webRoutes.post(.catchall, use: responseController.handle)
    }
    
}
