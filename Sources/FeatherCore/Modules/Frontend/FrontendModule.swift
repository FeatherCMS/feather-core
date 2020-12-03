//
//  FrontendModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

public final class FrontendModule: ViperModule {

    public static let name = "frontend"
    public var priority: Int { 2000 }
    
    public var router: ViperRouter? = FrontendRouter()
    
    public var migrations: [Migration] {
        [
            FrontendMetadataMigration_v1_0_0()
        ]
    }

    public static var bundleUrl: URL? {
        Bundle.module.resourceURL?
            .appendingPathComponent("Bundles")
            .appendingPathComponent(name.capitalized)
    }

    public func boot(_ app: Application) throws {
        app.hooks.register("routes", use: (router as! FrontendRouter).routesHook)
        app.hooks.register("admin", use: (router as! FrontendRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
    }
    
    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Frontend",
            "icon": "layout",
            "permission": "frontend",
            "items": LeafData.array([
                [
                    "url": "/admin/frontend/metadatas/",
                    "label": "Metadatas",
                    "permission": "frontend.metadatas.list",
                ],
            ])
        ]
    }
    
    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        [
            /// user
            ["key": "frontend",                     "name": "Frontend module"],
            /// variables
            ["key": "frontend.metadatas.list",      "name": "Frontend metadata list"],
            ["key": "frontend.metadatas.create",    "name": "Frontend metadata create"],
            ["key": "frontend.metadatas.update",    "name": "Frontend metadata update"],
            ["key": "frontend.metadatas.delete",    "name": "Frontend metadata delete"],
        ]
    }
}

