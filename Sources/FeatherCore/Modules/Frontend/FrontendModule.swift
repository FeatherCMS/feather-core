//
//  FrontendModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

public final class FrontendModule: ViperModule {

    public static let name = "frontend"
    public var priority: Int { 100 }
    
    public var router: ViperRouter? = FrontendRouter()
    
    public var migrations: [Migration] {
        Metadata.migrations()
    }
    
    public var bundleUrl: URL? {
        Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Frontend")
    }

    public func boot(_ app: Application) throws {
        app.hooks.register("routes", use: (router as! FrontendRouter).routesHook)
        app.hooks.register("admin", use: (router as! FrontendRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
    }
    
    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> [String: LeafDataRepresentable] {
        [
            "name": "Frontend",
            "icon": "layout",
            "items": LeafData.array([
                [
                    "url": "/admin/frontend/metadatas/",
                    "label": "Metadatas",
                ],
            ])
        ]
    }
}

