//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

public extension HookName {
    static let installWebPages: HookName = "install-web-pages"
    static let installWebMenuItems: HookName = "install-web-menu-items"
    
    static let webCss: HookName = "web-css"
}

struct WebModule: FeatherModule {
    
    let router = WebRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(WebMigrations.v1())

        app.databases.middleware.use(MetadataModelMiddleware<WebPageModel>())
        
        app.hooks.register(.installCommonVariables, use: installCommonVariablesHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)
        app.hooks.register(.webMiddlewares, use: webMiddlewaresHook)
        app.hooks.register(.webCss, use: webCssHook)
        
        app.hooks.registerAsync(.install, use: installHook)
        app.hooks.registerAsync(.response, use: responseHook)
        
        app.hooks.registerAsync("web-welcome-page", use: webWelcomePageHook)
        
        try router.boot(app)
    }

    // MARK: - hooks
    
    func installHook(args: HookArguments) async throws {
        
        let mainMenu = WebMenuModel(id: .init(), key: "main", name: "Main menu", notes: nil)
        try await mainMenu.create(on: args.req.db)
        
        let aboutMenuItem = WebMenuItemModel(label: "About", url: "/about/", priority: 0, menuId: mainMenu.uuid)
        try await aboutMenuItem.create(on: args.req.db)
        
        var arguments = HookArguments()
        arguments["menuId"] = mainMenu.uuid
        let menuItems: [Web.MenuItem.Create] = args.req.invokeAllFlat(.installWebMenuItems, args: arguments)
        let items = menuItems.map { item -> WebMenuItemModel in
            WebMenuItemModel(id: .init(),
                             icon: item.icon,
                             label: item.label,
                             url: item.url,
                             priority: item.priority,
                             isBlank: item.isBlank,
                             permission: item.permission,
                             menuId: item.menuId)
        }
        try await items.create(on: args.req.db)

        let footerMenu = WebMenuModel(id: .init(), key: "footer", name: "Footer menu", notes: nil)
        try await footerMenu.create(on: args.req.db)

        let footerItems = [
            WebMenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, isBlank: true, menuId: footerMenu.uuid),
            WebMenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, isBlank: true, menuId: footerMenu.uuid),
        ]
        try await footerItems.create(on: args.req.db)
        
        // MARK: pages

        let pageItems: [Web.Page.Create] = args.req.invokeAllFlat(.installWebPages)
        let pages = pageItems.map { WebPageModel(title: $0.title, content: $0.content) }
        try await pages.create(on: args.req.db)
        try await pages.forEachAsync { try await $0.publishMetadata(args.req) }
        
        let aboutPage = WebPageModel(title: "About", content: "This is an example about page.")
        try await aboutPage.create(on: args.req.db)
        try await aboutPage.publishMetadata(args.req)
        
        let homePage = WebPageModel(title: "Welcome", content: "[web-welcome-page]")
        try await homePage.create(on: args.req.db)
        try await homePage.publishMetadataAsHome(args.req)
    }

    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        var permissions = Web.availablePermissions()
        permissions += Web.Page.availablePermissions()
        permissions += Web.Menu.availablePermissions()
        permissions += Web.MenuItem.availablePermissions()
        permissions += Web.Metadata.availablePermissions()
        return permissions.map { .init($0) }
    }

    func webWelcomePageHook(args: HookArguments) async throws -> Response? {
        let template = WebWelcomePageTemplate(.init(index: .init(title: "Welcome"),
                                                    title: "Welcome",
                                                    message: "This is the welcome page"))
        return args.req.templates.renderHtml(template)
    }
    
    func installCommonVariablesHook(args: HookArguments) -> [Common.Variable.Create] {
        [
            .init(key: "webSiteNoIndex",
                  name: "Disable site index",
                  notes: "Disable site indexing by search engines"),
            
            .init(key: "webSiteLogo",
                  name: "Site logo",
                  notes: "Logo of the website"),
        
            .init(key: "webSiteTitle",
                  name: "Site title",
                  value: "Feather",
                  notes: "Title of the website"),
        
            .init(key: "webSiteExcerpt",
                  name: "Site excerpt",
                  value: "Feather is an open-source CMS written in Swift using Vapor 4.",
                  notes: "Excerpt for the website"),
        
            .init(key: "webSiteCss",
                  name: "Site CSS",
                  notes: "Global CSS injection for the site"),
        
            .init(key: "webSiteJs",
                  name: "Site JS",
                  notes: "Global JavaScript injection for the site"),
        
            .init(key: "welcomePageIcon",
                  name: "Welcome page icon",
                  value: "🪶",
                  notes: "Icon of the welcome page"),

            .init(key: "welcomePageTitle",
                  name: "Welcome page title",
                  value: "Welcome",
                  notes: "Title of the welcome page"),
            
            .init(key: "welcomePageExcerpt",
                  name: "Welcome page excerpt",
                  value: "This is your brand new Feather CMS powered website",
                  notes: "Excerpt for the welcome page"),

            .init(key: "welcomePageLinkLabel",
                  name: "Welcome page link label",
                  value: "Start customizing →",
                  notes: "Link label of the welcome page"),

            .init(key: "welcomePageLinkUrl",
                  name: "Welcome page link url",
                  value: "/admin/",
                  notes: "Link URL of the welcome page"),
        ]
    }

    func webCssHook(args: HookArguments) -> [OrderedHookResult<String>] {
        [
//            .init("/css/web/local.css", order: 420)
        ]
    }

    func responseHook(args: HookArguments) async throws -> Response? {
        let page = try await WebPageModel
            .queryJoinVisibleMetadata(on: args.req.db)
            .filterMetadataBy(path: args.req.url.path).first()

        guard let page = page else {
            return nil
        }

        /// if the content of a page has a page tag, then we respond with the corresponding page hook function
        let content = page.content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if content.hasPrefix("["), content.hasSuffix("-page]") {
            let name = String(content.dropFirst().dropLast())
            var pageArgs = HookArguments()
            pageArgs.metadata = page.featherMetadata
      
            let response: Response? = try await args.req.invokeAllFirstAsync(.init(stringLiteral: name), args: pageArgs)
            if let response = response {
                return response
            }
        }
        
        let data = try await WebPageApiController().detailOutput(args.req, page)
        let template = WebPageTemplate(.init(index: .init(title: page.title), page: data))
        return args.req.templates.renderHtml(template)
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            WebMenuMiddleware(),
            WebErrorMiddleware(),
        ]
    }

    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        if args.req.checkPermission(Web.permission(for: .detail)) {
            return [
                WebAdminWidgetTemplate(),
            ]
        }
        return []
    }
}
