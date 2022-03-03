//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

struct SystemVariableEditor: FeatherModelEditor {
    let model: SystemVariableModel
    let form: AbstractForm
    
    init(model: SystemVariableModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        InputField("key")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.key }
            .write { model.key = $1.input }
        
        InputField("name")
            .config {
                $0.output.context.label.required = true
            }
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

