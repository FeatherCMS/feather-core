//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct WebMenuItemEditor: FeatherModelEditor {
    let model: WebMenuItemModel
    let form: FeatherForm

    init(model: WebMenuItemModel, form: FeatherForm) {
        self.model = model
        self.form = form
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
