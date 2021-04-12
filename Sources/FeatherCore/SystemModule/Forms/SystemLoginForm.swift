//
//  UserLoginForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

final class SystemLoginForm: Form {

    var email = FormField<String>(key: "email")
    var password = FormField<String>(key: "password")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [email, password]
    }
    
    var templateData: TemplateData {
        .dictionary([
            "fields": fieldsTemplateData,
            "notification": .string(notification),
        ])
    }

    init() {}
}
