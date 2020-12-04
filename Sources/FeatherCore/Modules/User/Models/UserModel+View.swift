//
//  UserModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

extension UserModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "email": email,
        ])
    }
}

extension UserModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: id!.uuidString, label: email)
    }
}
