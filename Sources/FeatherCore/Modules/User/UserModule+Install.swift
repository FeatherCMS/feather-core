//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//


extension UserModule {
        
    func installModelsHook(args: HookArguments) -> EventLoopFuture<Void> {
        let req = args.req

        /// gather the main menu items through a hook function then map them
        let permissionItems: [[PermissionCreateObject]] = req.invokeAll(.installPermissions)
        let permissionModels = permissionItems.flatMap { $0 }.map {
            UserPermissionModel(namespace: $0.namespace, context: $0.context, action: $0.action, name: $0.name, notes: $0.notes)
        }
        let roles = [
            UserRoleModel(key: "editors", name: "Editors", notes: "Just an example role for editors, feel free to select permissions."),
        ]
//        let users = [
            //UserAccountModel(email: "root@feathercms.com", password: try! Bcrypt.hash("FeatherCMS"), root: true),
//        ]

        /// we persist the pages to the database
        return req.eventLoop.flatten([
            /// save home page and set it as a published root page by altering the metadata
            permissionModels.create(on: req.db),
            roles.create(on: req.db),
//            users.create(on: req.db),
        ])
    }
    
    func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
        var permissions: [PermissionCreateObject] = [
            UserModule.hookInstallPermission(for: .custom("admin"))
        ]
        permissions += UserAccountModel.hookInstallPermissions()
        permissions += UserRoleModel.hookInstallPermissions()
        permissions += UserPermissionModel.hookInstallPermissions()
        
        return permissions
    }
    
   

}
