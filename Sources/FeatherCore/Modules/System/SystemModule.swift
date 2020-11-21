//
//  SystemModule.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

final class SystemModule: ViperModule {

    static var name: String = "system"
    var priority: Int { 1 }

    var router: ViperRouter? { SystemRouter() }

    var migrations: [Migration] {
        [
            SystemMigration_v1_0_0(),
        ]
    }
    
    var middlewares: [Middleware] {
        [
            RequestVariablesMiddleware(),
            SystemInstallGuardMiddleware(),
        ]
    }
    
    var bundleUrl: URL? {
        Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Bundles")
            .appendingPathComponent("System")
    }

    func boot(_ app: Application) throws {
        app.hooks.register("admin", use: (router as! SystemRouter).adminRoutesHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        app.hooks.register("installer", use: installerHook)
        
        app.hooks.register("prepare-variables", use: prepareVariablesHook)
        app.hooks.register("set-variable", use: setVariableHook)
        app.hooks.register("unset-variable", use: unsetVariableHook)

        app.hooks.register("frontend-page", use: frontendPageHook)
    }
    
    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "System",
            "icon": "settings",
            "items": LeafData.array([
                [
                    "url": "/admin/system/variables/",
                    "label": "Variables",
                ],
            ])
        ]
    }

    func installerHook(args: HookArguments) -> ViperInstaller {
        SystemInstaller()
    }
    

    func prepareVariablesHook(args: HookArguments) -> EventLoopFuture<[String:String]> {
        let req = args["req"] as! Request
        return SystemVariableModel.query(on: req.db).all().map { variables in
            var items: [String: String] = [:]
            for variable in variables {
                items[variable.key] = variable.value
            }
            return items
        }
    }
    
    func setVariableHook(args: HookArguments) -> EventLoopFuture<Bool> {
        let req = args["req"] as! Request
        
        guard
            let key = args["key"] as? String,
            let value = args["value"] as? String
        else {
            return req.eventLoop.future(false)
        }

        let hidden = args["hidden"] as? Bool
        let notes = args["notes"] as? String

        return SystemVariableModel
            .query(on: req.db)
            .filter(\.$key == key)
            .first()
            .flatMap { model -> EventLoopFuture<Bool> in
                if let model = model {
                    model.value = value
                    if let hidden = hidden {
                        model.hidden = hidden
                    }
                    model.notes = notes
                    return model.update(on: req.db).map { true }
                }
                return SystemVariableModel(key: key,
                                           value: value,
                                           hidden: hidden ?? false,
                                           notes: notes)
                    .create(on: req.db)
                    .map { true }
            }
    }
    
    func unsetVariableHook(args: HookArguments) -> EventLoopFuture<Bool> {
        let req = args["req"] as! Request
        guard let key = args["key"] as? String else {
            return req.eventLoop.future(false)
        }
        return SystemVariableModel
            .query(on: req.db)
            .filter(\.$key == key)
            .delete()
            .map { true }
    }
 
    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?>? {
        let req = args["req"] as! Request

        /// check if system is already installed, if yes we don't do anything
        if req.variables.get("system.installed") == "true" {
            return nil
        }

        /// if the system path equals install, we render the start install screen
        guard req.url.path == "/system/install/" else {
            return req.leaf.render("System/Install/Start").encodeOptionalResponse(for: req)
        }
    
        /// create assets path under the public directory
        let assetsPath = Application.Paths.assets

        do {
            try FileManager.default.createDirectory(atPath: Application.Paths.assets,
                                                    withIntermediateDirectories: true,
                                                    attributes: [.posixPermissions: 0o744])
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        /// copy module assets if necessary
        for module in req.application.viper.modules {
            let name = module.name.lowercased()
            guard let moduleBundle = module.bundleUrl else {
                continue
            }

            let sourcePath = moduleBundle.appendingPathComponent("Assets").appendingPathComponent("install").path
            let destinationPath = assetsPath + name + "/"

            do {
                var isDir : ObjCBool = false
                if FileManager.default.fileExists(atPath: sourcePath, isDirectory: &isDir), isDir.boolValue {
                    try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
                }
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }

        /// we gather the system variables, based on the dictionary
        var variables: [SystemVariableModel] = []
        /// we request the install futures for the database model creation
        var modelInstallFutures: [EventLoopFuture<Void>] = []

        /// we request the installer objects, then use them to install everything
        let installers: [ViperInstaller] = req.invokeAll("installer")
        for installer in installers {
            let vars = installer.variables().compactMap { dict -> SystemVariableModel? in
                guard let key = dict["key"] as? String, !key.isEmpty else {
                    return nil
                }
                let value = dict["value"] as? String
                let hidden = dict["hidden"] as? Bool ?? false
                let notes = dict["notes"] as? String
                return SystemVariableModel(key: key, value: value, hidden: hidden, notes: notes)
            }
            variables.append(contentsOf: vars)

            if let future = installer.createModels(req) {
                modelInstallFutures.append(future)
            }
        }
        /// we combine the existing futures and call them
        let futures = [variables.create(on: req.db)] + modelInstallFutures
        return req.eventLoop.flatten(futures)
        .flatMap { _ in req.variables.set("system.installed", value: "true", hidden: true) }
        .flatMap { _ in req.leaf.render("System/Install/Finish") }
        .encodeOptionalResponse(for: req)
    }
}
