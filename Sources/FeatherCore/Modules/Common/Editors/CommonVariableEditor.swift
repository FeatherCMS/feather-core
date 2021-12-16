//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Foundation

struct CommonVariableEditor: FeatherModelEditor {
    let model: CommonVariableModel
    let form: FeatherForm
    
    init(model: CommonVariableModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    @FormComponentBuilder
    var formFields: [FormComponent] {
        InputField("key")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.key }
            .write { model.key = $1.input }
        
        InputField("name")
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }

        TextareaField("value")
            .read { $1.output.context.value = model.value }
            .write { model.value = $1.input }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }
}

