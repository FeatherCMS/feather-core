//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct WebMenuItemEditor: FeatherModelEditor {
    let model: WebMenuItemModel

    init(model: WebMenuItemModel) {
        self.model = model
    }

    var formFields: [FormComponent] {
        InputField("label")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.label }
            .write { model.label = $1.input }
    }
}
