//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 09..
//

extension SystemModule {
        
    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args["req"] as! Request
        
        let mainId = UUID()
        let mainMenu = SystemMenuModel(id: mainId, key: "main", name: "Main menu")
        
        /// gather the main menu items through a hook function then map them
        let menuItems: [[SystemMenuItem]] = req.invokeAll("install-main-menu-items")
        var mainMenuItemModels = menuItems.flatMap { $0 }.compactMap {
            SystemMenuItemModel(icon: $0.icon, label: $0.label, url: $0.url, priority: $0.priority, isBlank: $0.isBlank, menuId: mainId)
        }
        
        /// we add an about menu item
        let aboutMenuItem = SystemMenuItemModel(label: "About", url: "/about/", priority: 0, menuId: mainId)
        mainMenuItemModels.insert(aboutMenuItem, at: 0)
        
        let footerId = UUID()
        let footerMenu = SystemMenuModel(id: footerId, key: "footer", name: "Footer menu")
        
        let footerItems = [
            SystemMenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, isBlank: true, menuId: footerId),
            SystemMenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, isBlank: true, menuId: footerId),
        ]
        
        /// we expect a key-value array of static page install elements with title and content keys
        let pages: [[SystemPage]] = req.invokeAll("install-pages")
        var pageModels = pages.flatMap({ $0 }).map {
            SystemPageModel(title: $0.title, content: $0.content)
        }
        
        /// create home page with a hookable page content
        let homePage = SystemPageModel(title: "Home", content: "[home-page]")
        
        /// create a sample about page
        let aboutPage = SystemPageModel(title: "About", content: "About.html")
        pageModels.append(aboutPage)
        
        /// gather the main menu items through a hook function then map them
        let permissionItems: [[SystemPermission]] = req.invokeAll("install-permissions")
        let permissionModels = permissionItems.flatMap { $0 }.map {
            SystemPermissionModel(namespace: $0.namespace, context: $0.context, action: $0.action, name: $0.name, notes: $0.notes)
        }
        let roles = [
            SystemRoleModel(key: "editors", name: "Editors", notes: "Just an example role for editors, feel free to select permissions."),
        ]
        let users = [
            SystemUserModel(email: "root@feathercms.com", password: try! Bcrypt.hash("FeatherCMS"), root: true),
        ]

        let variableItems: [[SystemVariable]] = req.invokeAll("install-variables")
        let systemVariableModels = variableItems.flatMap { $0 }.map {
            SystemVariableModel(key: $0.key, name: $0.name, value: $0.value, notes: $0.notes)
        }
        
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
            permissionModels.create(on: req.db),
            roles.create(on: req.db),
            users.create(on: req.db),
            systemVariableModels.create(on: req.db),
        ])
    }
    
    func installPermissionsHook(args: HookArguments) -> [SystemPermission] {
        var permissions: [SystemPermission] = [
            SystemModule.systemPermission(for: .custom("view"))
        ]
        permissions += SystemUserModel.systemPermissions()
        permissions += SystemRoleModel.systemPermissions()
        permissions += SystemPermissionModel.systemPermissions()
        permissions += SystemVariableModel.systemPermissions()
        permissions += SystemMetadataModel.systemPermissions()
        permissions += SystemMenuModel.systemPermissions()
        permissions += SystemMenuItemModel.systemPermissions()
        permissions += SystemPageModel.systemPermissions()

        return permissions
    }
    
    func installVariablesHook(args: HookArguments) -> [SystemVariable] {
        [
            .init(key: "siteNoindex",
                  name: "Site noindex",
                  notes: "Disable site indexing by search engines"),
            
            .init(key: "siteLogo",
                  name: "Site logo",
                  notes: "Logo of the website"),
            
            .init(key: "siteTitle",
                  value: "Feather",
                  name: "Site title",
                  notes: "Title of the website"),
            
            .init(key: "siteExcerpt",
                  value: "Feather is an open-source CMS written in Swift using Vapor 4.",
                  name: "Site excerpt",
                  notes: "Excerpt for the website"),

            .init(key: "siteContentFilters",
                  name: "Content filters",
                  notes: "Coma separated list of content filter identifiers"),
            
            .init(key: "siteCss",
                  name: "Site CSS",
                  notes: "Global CSS injection for the site"),
            
            .init(key: "siteJs",
                  name: "Site JS",
                  notes: "Global JavaScript injection for the site"),
            
            .init(key: "siteFooterTop",
                  value: """
                        <img class="size" src="/images/icons/icon.png" alt="Logo of Feather" title="Feather">
                        <p>This site is powered by <a href="https://feathercms.com/" target="_blank">Feather CMS</a> &copy; 2020 - {year}</p>
                    """,
                  name:  "Site footer top section",
                  notes: "Top footer content placed above the footer menu"),

            .init(key: "siteFooterBottom",
                  name: "Site footer bottom",
                  notes: "Bottom footer content placed under the footer menu"),
            
            // MARK: - home page
            
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
            
            
            // MARK: - not found

            .init(key: "notFoundPageIcon",
                  value:  "🙉",
                  name: "Page not found icon",
                  notes: "Icon for the not found page"),
            
            .init(key: "notFoundPageTitle",
                  value: "Page not found",
                  name: "Page not found title",
                  notes: "Title of the not found page"),
            
            .init(key: "notFoundPageExcerpt",
                  value: "Unfortunately the requested page is not available.",
                  name: "Page not found excerpt",
                  notes: "Excerpt for the not found page"),

            .init(key: "notFoundPageLinkLabel",
                  value: "Go to the home page →",
                  name: "Page not found link label",
                  notes: "Retry link text for the not found page"),

            .init(key: "notFoundPageLinkUrl",
                  value: "/",
                  name: "Page not found link URL",
                  notes: "Retry link URL for the not found page"),

            // MARK: - empty list
            
            .init(key: "emptyListIcon",
                  value: "🔍",
                  name: "Empty list icon",
                  notes: "Icon for the empty list results view."),
            
            .init(key: "emptyListTitle",
                  value: "Empty list",
                  name: "Empty list title",
                  notes: "Title for the empty list results view."),
            
            .init(key: "emptyListDescription",
                  value: "Unfortunately there are no results.",
                  name: "Empty list description",
                  notes: "Description of the empty list box"),
            
            .init(key: "emptyListLinkLabel",
                  value: "Try again from scratch →",
                  name: "Empty list link label",
                  notes: "Start over link text for the empty list box"),
        ]
    }

}
