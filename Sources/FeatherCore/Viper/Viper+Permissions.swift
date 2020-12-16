//
//  Viper+Permissions.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

public extension ViperModel {

    /// easily return permissions for CRUD operations for models
    static var permissions: [[String: Any]] {
        let crud = ["list", "get", "create", "update", "delete"]
        var permissions: [[String: Any]] = []
        let name = Self.name.lowercased().replacingOccurrences(of: "_", with: " ")
        let ctx = Self.name.lowercased().replacingOccurrences(of: "_", with: ".")

        for action in crud {
            let name = [action.capitalized, name].joined(separator: " ")
            permissions.append([
                "module": Module.name.lowercased(),
                "context": ctx,
                "action": action,
                "name": name,
            ])
        }
        return permissions
    }
}

public extension ViperModule {

    /// returns basic module access permission
    static var permissions: [[String: Any]] {
        [
            [
                "module": Self.name.lowercased(),
                "context": "module",
                "action": "access",
                "name": Self.name.lowercased().capitalized + " module access",
            ]
        ]
    }
}



