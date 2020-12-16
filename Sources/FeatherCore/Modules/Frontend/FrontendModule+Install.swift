//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

extension FrontendModule {

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
        let aboutPage = FrontendPageModel(title: "About", content: FrontendModule.sample(asset: "About.html"))
        pageModels.append(aboutPage)

        /// we persist the pages to the database
        return req.eventLoop.flatten([
            /// save home page and set it as a published root page by altering the metadata
            homePage.create(on: req.db).flatMap { homePage.publishAsHomePage(on: req.db) },
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
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        FrontendModule.permissions +
        FrontendMetadataModel.permissions +
        FrontendMenuModel.permissions +
        FrontendMenuItemModel.permissions +
        FrontendPageModel.permissions +
            [
                [
                    "module": FrontendModule.name,
                    "context": "settings",
                    "action": "update",
                    "name": "Frontend settings update"
                ],
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
                "key": "frontend.site.filters",
                "name": "Default content filters",
                "note": "Coma separated list of default content filters",
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
                "key": "frontend.site.copy.prefix",
                "name": "Site copy prefix",
                "note": "Can be used to place a start year before the current one in the copy line",
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
}
