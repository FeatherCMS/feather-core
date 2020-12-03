//
//  UserModule+Install.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

struct UserInstaller: ViperInstaller {

    func createModels(_ req: Request) -> EventLoopFuture<Void>? {

        /// gather the main menu items through a hook function then map them
        let permissionItems: [[[String: Any]]] = req.invokeAll("user-permission-install")
        let permissionModels = permissionItems.flatMap { $0 }.compactMap { item -> UserPermissionModel? in
            guard let key = item["key"] as? String else {
                return nil
            }
            let name = item["name"] as? String
            let notes = item["notes"] as? String
            return UserPermissionModel(key: key, name: name, notes: notes)
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
}
