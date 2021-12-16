//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct UserRoleEditor: FeatherModelEditor {
    let model: UserRoleModel

    init(model: UserRoleModel) {
        self.model = model
    }

    var formFields: [FormComponent] {
        InputField("key")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator($1, "Key must be unique") { field, req in
                    await Model.isUniqueBy(\.$key == field.input, req: req)
                }
            }
            .read { $1.output.context.value = model.key }
            .write { model.key = $1.input }
        
        InputField("name")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }
}
