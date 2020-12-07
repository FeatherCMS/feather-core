//
//  UserPermissionModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

extension UserPermissionModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "key": key,
            "name": name,
            "notes": notes,
        ])
    }
}

extension UserPermissionModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: id!.uuidString, label: name)
    }
}
