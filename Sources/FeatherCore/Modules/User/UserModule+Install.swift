//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

extension UserModule {

    func modelInstallHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args["req"] as! Request

        /// gather the main menu items through a hook function then map them
        let permissionItems: [[[String: Any]]] = req.invokeAll("user-permission-install")
        let permissionModels = permissionItems.flatMap { $0 }.compactMap { item -> UserPermissionModel? in
            guard
                let module = item["module"] as? String, !module.isEmpty,
                let context = item["context"] as? String, !context.isEmpty,
                let action = item["action"] as? String, !action.isEmpty,
                let name = item["name"] as? String, !name.isEmpty
            else {
                return nil
            }
            let notes = item["notes"] as? String

            return UserPermissionModel(module: module, context: context, action: action, name: name, notes: notes)
        }
        let roles = [
            UserRoleModel(key: "editors", name: "Editors", notes: "Just an example role for editors, feel free to select permissions."),
        ]
        let users = [
            UserModel(email: "feather@binarybirds.com", password: try! Bcrypt.hash("FeatherCMS"), root: true),
        ]
        return req.eventLoop.flatten([
            permissionModels.create(on: req.db),
            roles.create(on: req.db),
            users.create(on: req.db),
        ])
    }

    func userPermissionInstallHook(args: HookArguments) -> [[String: Any]] {
        UserModule.permissions +
        UserModel.permissions +
        UserRoleModel.permissions +
        UserPermissionModel.permissions
    }
}

