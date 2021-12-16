//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct WebMenuEditor: FeatherModelEditor {
    let model: WebMenuModel
    let form: FeatherForm

    init(model: WebMenuModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    var formFields: [FormComponent] {
        InputField("key")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.key }
            .write { model.key = $1.input }
    }
}
