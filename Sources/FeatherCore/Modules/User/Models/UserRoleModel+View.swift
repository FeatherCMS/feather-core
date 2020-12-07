//
//  UserRoleModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

extension UserRoleModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "key": key,
            "name": name,
            "notes": notes,
            "permissions": $permissions.value != nil ? permissions.map(\.leafData) : [],
        ])
    }
}

extension UserRoleModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: id!.uuidString, label: name)
    }
}
