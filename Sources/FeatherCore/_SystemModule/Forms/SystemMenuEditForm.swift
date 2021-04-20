//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct SystemMenuEditForm: EditFormController {
    
    var context: EditFormContext<SystemMenuModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Key is required") { !$0.input.isEmpty },
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .read { $1.output.value = context.model?.key }
                .write { context.model?.key = $1.input },

            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.name }
                .write { context.model?.name = $1.input },

            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },

        ]
    }
}
