//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

struct WebPageEditor: FeatherModelEditor {
    let model: WebPageModel

    init(model: WebPageModel) {
        self.model = model
    }

    var formFields: [FormComponent] {
        InputField("title")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
    }
}
