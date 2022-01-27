//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct WebMenuEditor: FeatherModelEditor {
    let model: WebMenuModel
    let form: AbstractForm

    init(model: WebMenuModel, form: AbstractForm) {
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
                FormFieldValidator($1, "Key must be unique") { req, field in
                    try await Model.isUnique(req, \.$key == field.input, Web.Menu.getIdParameter(req))
                }
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
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
    }
}
