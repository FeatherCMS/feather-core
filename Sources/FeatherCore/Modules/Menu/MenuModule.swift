//
//  MenuModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class MenuModule: ViperModule {

    static let name = "menu"

    var router: ViperRouter? = MenuRouter()

    var migrations: [Migration] {
        [
            MenuMigration_v1_0_0(),
        ]
    }
    
    var middlewares: [Middleware] {
        [
            PublicMenusMiddleware(),
        ]
    }

    static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent(name.capitalized)
    }

    // NOTE: this is a core dependency -> FeatherCore?
    func leafDataGenerator(for req: Request) -> [String: LeafDataGenerator]? {
        req.menus.all.mapValues { .lazy(LeafData($0)) }
    }

    func boot(_ app: Application) throws {
        app.hooks.register("admin", use: (router as! MenuRouter).adminRoutesHook)
        app.hooks.register("installer", use: installerHook)
        app.hooks.register("prepare-menus", use: prepareMenusHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
    }

    // MARK: - hooks

    func installerHook(args: HookArguments) -> ViperInstaller {
        MenuInstaller()
    }
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            /// user
            ["key": "menu",                 "name": "Menu module"],
            /// menu menus
            ["key": "menu.menus.list",      "name": "Menu list"],
            ["key": "menu.menus.create",    "name": "Menu create"],
            ["key": "menu.menus.update",    "name": "Menu update"],
            ["key": "menu.menus.delete",    "name": "Menu delete"],
            /// menu items
            ["key": "menu.items.list",      "name": "Menu item list"],
            ["key": "menu.items.create",    "name": "Menu item create"],
            ["key": "menu.items.update",    "name": "Menu item update"],
            ["key": "menu.items.delete",    "name": "Menu item delete"],
        ]
    }
    
    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Menu",
            "icon": "compass",
            "permission": "menu",
            "items": LeafData.array([
                [
                    "url": "/admin/menu/menus/",
                    "label": "Menus",
                    "permission": "menu.menus.list",
                ],
            ])
        ]
    }

    func prepareMenusHook(args: HookArguments) -> EventLoopFuture<[String:LeafDataRepresentable]> {
        let req = args["req"] as! Request
        return MenuModel.query(on: req.db).with(\.$items).all()
        .map { menus in
            var items: [String: LeafDataRepresentable] = [:]
            for menu in menus {
                items[menu.key] = menu.leafData
            }
            return items
        }
    }

    
}
