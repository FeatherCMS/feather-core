//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor

struct UserAccountEditor: FeatherModelEditor {
    let model: UserAccountModel

    init(model: UserAccountModel) {
        self.model = model
    }

    var formFields: [FormComponent] {
        InputField("email")
            .config {
                $0.output.context.type = .email
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator.email($1)
            }
            .read { $1.output.context.value = model.email }
            .write { model.email = $1.input }

        InputField("password")
            .config {
                $0.output.context.type = .password
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .write { model.password = $1.input }
    }
}
