//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

extension FrontendModule {
        
    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args.req
        
        let mainId = UUID()
        let mainMenu = FrontendMenuModel(id: mainId, key: "main", name: "Main menu")
        
        /// gather the main menu items through a hook function then map them
        let menuItems: [[FrontendMenuItem]] = req.invokeAll("install-main-menu-items")
        var mainMenuItemModels = menuItems.flatMap { $0 }.compactMap {
            FrontendMenuItemModel(icon: $0.icon, label: $0.label, url: $0.url, priority: $0.priority, isBlank: $0.isBlank, menuId: mainId)
        }
        
        /// we add an about menu item
        let aboutMenuItem = FrontendMenuItemModel(label: "About", url: "/about/", priority: 0, menuId: mainId)
        mainMenuItemModels.insert(aboutMenuItem, at: 0)
        
        let footerId = UUID()
        let footerMenu = FrontendMenuModel(id: footerId, key: "footer", name: "Footer menu")
        
        let footerItems = [
            FrontendMenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, isBlank: true, menuId: footerId),
            FrontendMenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, isBlank: true, menuId: footerId),
        ]
        
        /// we expect a key-value array of static page install elements with title and content keys
        let pages: [[FrontendPage]] = req.invokeAll("install-pages")
        var pageModels = pages.flatMap({ $0 }).map {
            FrontendPageModel(title: $0.title, content: $0.content)
        }
        
        /// create home page with a hookable page content
        let homePage = FrontendPageModel(title: "Home", content: "[home-page]")
        
        /// create a sample about page
        let aboutPage = FrontendPageModel(title: "About", content: "About.html")
        pageModels.append(aboutPage)

        /// we persist the pages to the database
        return req.eventLoop.flatten([
            /// save home page and set it as a published root page by altering the metadata
            homePage.create(on: req.db).flatMap {
                homePage.publishMetadataAsHome(on: req.db)
            },
            /// save pages, then we publish the associated metadatas
            pageModels.create(on: req.db).flatMap { _ in
                req.eventLoop.flatten(pageModels.map { $0.publishMetadata(on: req.db) })
            },
            /// finally create menu items
            [mainMenu, footerMenu].create(on: req.db).flatMap {
                (mainMenuItemModels + footerItems).create(on: req.db)
            },
        ])
    }
    
    func installPermissionsHook(args: HookArguments) -> [UserPermission] {
        var permissions: [UserPermission] = [
            FrontendModule.systemPermission(for: .custom("admin"))
        ]
        permissions += FrontendMetadataModel.systemPermissions()
        permissions += FrontendMenuModel.systemPermissions()
        permissions += FrontendMenuItemModel.systemPermissions()
        permissions += FrontendPageModel.systemPermissions()
        return permissions
    }
    
    func installVariablesHook(args: HookArguments) -> [CommonVariable] {
        [
            .init(key: "homePageIcon",
                  value: "🪶",
                  name: "Home page icon",
                  notes: "Icon of the home page"),

            .init(key: "homePageTitle",
                  value: "Welcome",
                  name: "Home page title",
                  notes: "Title of the home page"),
            
            .init(key: "homePageExcerpt",
                  value: "This is your brand new Feather CMS powered website",
                  name: "Home page excerpt",
                  notes: "Excerpt for the home page"),

            .init(key: "homePageLinkLabel",
                  value: "Start customizing →",
                  name: "Home page link label",
                  notes: "Link label of the home page"),

            .init(key: "homePageLinkUrl",
                  value: "/admin/",
                  name: "Home page link url",
                  notes: "Link URL of the home page"),
        ]
    }

}
