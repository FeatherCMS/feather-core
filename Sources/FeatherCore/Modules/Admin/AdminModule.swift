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
            .appendingPathComponent(name.capitalized)
    }

    func boot(_ app: Application) throws {
        app.hooks.register("routes", use: (router as! AdminRouter).routesHook)
    }
}
