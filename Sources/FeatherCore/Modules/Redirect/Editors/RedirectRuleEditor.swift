//
//  RedirectRuleEditor.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Foundation

struct RedirectRuleEditor: FeatherModelEditor {
    public enum StatusCodeOptions: String, Codable, CaseIterable {
        case normal = "303"
        case temporary = "301"
        case permanent = "307"
    }

    
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

        SelectField("statusCode")
            .config {
                $0.output.context.label.required = true
                
                $0.output.context.options = StatusCodeOptions.allCases.map { OptionContext(key: $0.rawValue, label: $0.rawValue.uppercasedFirst) }
                $0.output.context.value = StatusCodeOptions.normal.rawValue
            }
            .validators {
                FormFieldValidator($1, "Invalid status") { field, _ in
                    StatusCodeOptions(rawValue: field.input) != nil
                }
            }
            .read { $1.output.context.value = String(model.statusCode) }
            .write {
                let value = StatusCodeOptions(rawValue: $1.input) ?? StatusCodeOptions.normal
                model.statusCode = Int(value.rawValue)!
            }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }
}

