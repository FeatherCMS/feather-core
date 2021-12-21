//
//  RedirectRuleEditor.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Foundation

struct RedirectRuleEditor: FeatherModelEditor {
    let model: RedirectRuleModel
    let form: FeatherForm

    init(model: RedirectRuleModel, form: FeatherForm) {
        self.model = model
        self.form = form
    }

    @FormComponentBuilder
    var formFields: [FormComponent] {
        
        InputField("source")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.source }
            .write { model.source = $1.input }
        
        InputField("destination")
            .config {
                $0.output.context.label.required = true
            }
            .read { $1.output.context.value = model.destination }
            .write { model.destination = $1.input }
            .validators {
                FormFieldValidator.required($1)
            }

        InputField("statusCode")
            .config {
                $0.output.context.label.required = true
            }
            .read { $1.output.context.value = String(model.statusCode) }
            .write { model.statusCode = Int($1.input) ?? 303 }
            .validators {
                FormFieldValidator.required($1)
            }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }
}

