//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Foundation
import Vapor

struct UserAccountEditor: FeatherModelEditor {
    let model: UserAccountModel
    let form: FeatherForm

    init(model: UserAccountModel, form: FeatherForm) {
        self.model = model
        self.form = form
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
            .write { req, field in
                if !field.input.isEmpty {
                    model.password = try! Bcrypt.hash(field.input)
                }
            }

        ToggleField("root")
            .config {
                $0.output.context.label.title = "Has root access?"
            }
            .read { $1.output.context.value = model.isRoot }
            .write { model.isRoot = $1.input }
        
        CheckboxField("roles")
            .load { req, field in
                let items = try! await UserRoleModel.query(on: req.db).all()
                field.output.context.options = items.map { OptionContext(key: $0.identifier, label: $0.name) }
            }
            .read { req, field in
                field.output.context.values = model.roles.compactMap { $0.identifier }
            }
            .save { req, field in
                let values = field.input.compactMap { UUID(uuidString: $0) }
                return try! await model.$roles.reAttach(ids: values, on: req.db)
            }
    }
}
