//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

public extension HookName {
    static let installWebPages: HookName = "install-web-pages"
    static let installWebMenuItems: HookName = "install-web-menu-items"

    ///
    ///  A String containing the path of the logo without the png extension.
    ///
    ///  e.g. `site/my-logo`
    ///
    ///  Logo files should be located at the following URLs:
    ///     - `/img/[webLogo].png`
    ///     - `/img/[webLogo]-dark.png`
    ///
    static let webLogo: HookName = "web-logo"
    /// return a HeaderContext.Action item to display an action next to the menu
    static let webAction: HookName = "web-action"
    
    static let webCss: HookName = "web-css"
    static let webJs: HookName = "web-js"
}

struct WebModule: FeatherModule {
    
    static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundle")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Web")
    }
    
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
        
        app.hooks.registerAsync(.install, use: installHook)
        app.hooks.registerAsync(.response, use: responseHook)
        
//        app.hooks.registerAsync("web-welcome-page", use: webWelcomePageHook)
        
        try router.boot(app)
    }

    // MARK: - hooks
    
    func installHook(args: HookArguments) async throws {
        
        let mainMenu = WebMenuModel(id: .init(), key: "main", name: "Main", notes: nil)
        try await mainMenu.create(on: args.req.db)
        
        let aboutMenuItem = WebMenuItemModel(label: "About", url: "/about/", priority: 0, menuId: mainMenu.uuid)
        try await aboutMenuItem.create(on: args.req.db)
        
        var arguments = HookArguments()
        arguments["menuId"] = mainMenu.uuid
        let menuItems: [Web.MenuItem.Create] = args.req.invokeAllFlat(.installWebMenuItems, args: arguments)
        let items = menuItems.map { item -> WebMenuItemModel in
            WebMenuItemModel(id: .init(),
                             label: item.label,
                             url: item.url,
                             priority: item.priority,
                             isBlank: item.isBlank,
                             permission: item.permission,
                             menuId: item.menuId)
        }
        try await items.create(on: args.req.db, chunks: 25)
        
        // MARK: footer
        
        let footer1 = WebMenuModel(id: .init(), key: "footer-1", name: "Navigation", notes: nil)
        try await footer1.create(on: args.req.db)

        try await [
            WebMenuItemModel(label: "Home", url: "/", priority: 100, menuId: footer1.uuid),
            WebMenuItemModel(label: "About", url: "/about/", priority: 90, menuId: footer1.uuid),
        ].create(on: args.req.db)
        
        let footer2 = WebMenuModel(id: .init(), key: "footer-2", name: "Feed", notes: nil)
        try await footer2.create(on: args.req.db)

        try await [
            WebMenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 100, isBlank: true, menuId: footer2.uuid),
            WebMenuItemModel(label: "RSS", url: "/rss.xml", priority: 90, isBlank: true, menuId: footer2.uuid),
        ].create(on: args.req.db)
        
        let footer3 = WebMenuModel(id: .init(), key: "footer-3", name: "User", notes: nil)
        try await footer3.create(on: args.req.db)

        try await [
            WebMenuItemModel(label: "Admin", url: "/admin/", priority: 100, permission: "admin.module.detail", menuId: footer3.uuid),
            WebMenuItemModel(label: "Sign in", url: "/login/", priority: 90, permission: "user.account.login", menuId: footer3.uuid),
            WebMenuItemModel(label: "Sign out", url: "/logout/", priority: 90, permission: "user.account.logout", menuId: footer3.uuid),
        ].create(on: args.req.db)
        
        let footer4 = WebMenuModel(id: .init(), key: "footer-4", name: "Links", notes: nil)
        try await footer4.create(on: args.req.db)

        try await [
            WebMenuItemModel(label: "Feather", url: "https://feathercms.com/", priority: 100, isBlank: true, menuId: footer4.uuid),
            WebMenuItemModel(label: "Vapor", url: "https://vapor.codes/", priority: 90, isBlank: true, menuId: footer4.uuid),
            WebMenuItemModel(label: "Swift", url: "https://swift.org/", priority: 90, isBlank: true, menuId: footer4.uuid),
        ].create(on: args.req.db)
        
        // MARK: pages

        let pageItems: [Web.Page.Create] = args.req.invokeAllFlat(.installWebPages)
        let pages = pageItems.map { WebPageModel(title: $0.title, content: $0.content) }
        try await pages.create(on: args.req.db, chunks: 25)
        try await pages.forEachAsync { try await $0.publishMetadata(args.req) }
        
        let aboutPage = WebPageModel(title: "About", content: WebModule.sample(named: "About.md"))
        try await aboutPage.create(on: args.req.db)
        try await aboutPage.publishMetadata(args.req)
        
        let homePage = WebPageModel(title: "Welcome", content: WebModule.sample(named: "Welcome.md"))
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

//    func webWelcomePageHook(args: HookArguments) async throws -> Response? {
//        let template = WebWelcomePageTemplate(.init(index: .init(title: "Welcome"),
//                                                    title: "Welcome",
//                                                    message: "This is the welcome page"))
//        return args.req.templates.renderHtml(template)
//    }
    
    func installCommonVariablesHook(args: HookArguments) -> [Common.Variable.Create] {
        [
            .init(key: "webSiteNoIndex",
                  name: "Disable site index",
                  notes: "Disable site indexing by search engines"),
            
            .init(key: "webSiteLogo",
                  name: "Site logo",
                  notes: "Logo of the website"),
            
            .init(key: "webSiteLogoDark",
                  name: "Site logo (dark mode)",
                  notes: "Logo of the website in dark mode"),
        
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
        let template = WebPageTemplate(.init(page: data))
        return args.req.templates.renderHtml(template)
    }

    func webMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            WebMenuMiddleware(),
            WebErrorMiddleware(),
        ]
    }

    func adminWidgetsHook(args: HookArguments) -> [OrderedHookResult<TemplateRepresentable>] {
        if args.req.checkPermission(Web.permission(for: .detail)) {
            return [
                .init(WebAdminWidgetTemplate(), order: 900),
            ]
        }
        return []
    }
}
