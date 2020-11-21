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

    var bundleUrl: URL? {
        Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Bundles")
            .appendingPathComponent("Admin")
    }

    func boot(_ app: Application) throws {
        app.hooks.register("routes", use: (router as! AdminRouter).routesHook)
    }
}
