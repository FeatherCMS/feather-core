//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebPageEditor: FeatherModelEditor {
    let model: WebPageModel
    let form: FeatherForm

    init(model: WebPageModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    var formFields: [FormComponent] {
        InputField("title")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator($1, "Title must be unique") { field, req in
                    guard Model.getIdParameter(req: req) == nil else {
                        return true
                    }
                    return try await Model.isUniqueBy(\.$title == field.input, req: req)
                }
            }
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
        
        ContentField("content")
            .read { $1.output.context.value = model.content }
            .write { model.content = $1.input }
    }
}
