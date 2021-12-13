//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct UserRoleEditor: FeatherModelEditor {
    let model: UserRoleModel

    init(model: UserRoleModel) {
        self.model = model
    }

    var formFields: [FormComponent] {
        InputField("name")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }
    }
}
