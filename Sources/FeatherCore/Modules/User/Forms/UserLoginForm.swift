//
//  UserLoginForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

final class UserLoginForm: Form {

    var email = FormField<String>(key: "email")
    var password = FormField<String>(key: "password")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [email, password]
    }
    
    var leafData: LeafData {
        .dictionary([
            "fields": fieldsLeafData,
            "notification": .string(notification),
        ])
    }

    init() {}
}
