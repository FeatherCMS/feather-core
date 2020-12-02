//
//  MenuInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

/// installer component for the menu module
struct MenuInstaller: ViperInstaller {
    
    /// we create the menus with the associated menu items
    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        let mainId = UUID()
        let mainMenu = MenuModel(id: mainId, handle: "main", name: "Main menu")

        /// gather the main menu items through a hook function then map them
        let menuItems: [[[String: Any]]] = req.invokeAll("main-menu-install")
        var mainMenuItemModels = menuItems.flatMap { $0 }.compactMap { item -> MenuItemModel? in
            guard let label = item["label"] as? String, let url = item["url"] as? String else {
                return nil
            }
            let icon = item["icon"] as? String
            let targetBlank = item["targetBlank"] as? Bool ?? false
            let priority = item["priority"] as? Int ?? 100

            return MenuItemModel(icon: icon, label: label, url: url, priority: priority, targetBlank: targetBlank, menuId: mainId)
        }

        /// we add a home menu item as well with a relatively high priority
        let homeMenuItem = MenuItemModel(label: "Home", url: "/", priority: 1000, menuId: mainId)
        mainMenuItemModels.insert(homeMenuItem, at: 0)

        let footerId = UUID()
        let footerMenu = MenuModel(id: footerId, handle: "footer", name: "Footer menu")

        let footerItems = [
            MenuItemModel(label: "Sitemap", url: "/sitemap.xml", priority: 1000, targetBlank: true, menuId: footerId),
            MenuItemModel(label: "RSS", url: "/rss.xml", priority: 900, targetBlank: true, menuId: footerId),
        ]

        return [mainMenu, footerMenu].create(on: req.db).flatMap {
            (mainMenuItemModels + footerItems).create(on: req.db)
        }
    }
}
