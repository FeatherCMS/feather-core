//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct WebMenuItemEditor: FeatherModelEditor {
    let model: WebMenuItemModel
    let form: AbstractForm

    init(model: WebMenuItemModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {

        InputField("label")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.label }
            .write { model.label = $1.input }
        
        InputField("url")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.url }
            .write { model.url = $1.input }
        
        InputField("priority")
            .config {
                $0.output.context.value = String(100)
            }
            .read { $1.output.context.value = String(model.priority) }
            .write { model.priority = Int($1.input) ?? 100 }
        
        ToggleField("isBlank")
            .config {
                $0.output.context.label.title = "Open in new tab?"
            }
            .read { $1.output.context.value = model.isBlank }
            .write { model.isBlank = $1.input }
        
        InputField("permission")
            .read { $1.output.context.value = model.permission }
            .write { model.permission = $1.input }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.permission }
            .write { model.permission = $1.input }
        
    }
}
