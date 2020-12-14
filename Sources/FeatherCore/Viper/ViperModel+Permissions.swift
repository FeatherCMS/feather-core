//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 14..
//

extension ViperModel {

    static var permissions: [[String: Any]] {
        let crud = ["list", "get", "create", "update", "delete"]
        var permissions: [[String: Any]] = []
        for action in crud {
            let key = [Module.name.lowercased().capitalized, Self.name.lowercased(), action].joined(separator: ".")
            let name = [action.capitalized, Self.name.lowercased()].joined(separator: " ")
            permissions.append([
                "key": key,
                "name": name,
            ])
        }
        return permissions
    }
}
