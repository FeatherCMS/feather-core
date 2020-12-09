//
//  AdminModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 28..
//

final class AdminModule: ViperModule {

    static let name = "admin"
    var priority: Int { 2000 }

    var router: ViperRouter? = AdminRouter()

    static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Modules")
            .appendingPathComponent(name.capitalized)
    }

    func boot(_ app: Application) throws {
        app.hooks.register("routes", use: (router as! AdminRouter).routesHook)

        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
        app.hooks.register("system-variables-install", use: systemVariablesInstallHook)
    }

    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            ["key": "admin", "name": "Admin module"],
        ]
    }
    
    func systemVariablesInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            [
                "key": "empty.list.icon",
                "name": "Empty list icon",
                "value": "🔍",
                "note": "Icon for the empty list box",
            ],
            [
                "key": "empty.list.title",
                "name": "Empty list title",
                "value": "Empty list",
                "note": "Title of the empty list box",
            ],
            [
                "key": "empty.list.description",
                "name": "Empty list description",
                "value": "Unfortunately there are no results.",
                "note": "Description of the empty list box",
            ],
            [
                "key": "empty.list.link",
                "name": "Empty list link label",
                "value": "Try again from scratch →",
                "note": "Start over link text for the empty list box",
            ],
        ]
    }
}
