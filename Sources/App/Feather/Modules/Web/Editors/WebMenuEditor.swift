//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct WebMenuEditor: FeatherModelEditor {
    let model: WebMenuModel

    init(model: WebMenuModel) {
        self.model = model
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
