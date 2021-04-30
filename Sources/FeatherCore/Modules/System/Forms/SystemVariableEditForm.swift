//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//

struct SystemVariableEditForm: FeatherForm {

    var context: FeatherFormContext<CommonVariableModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read {
                    $1.output.value = context.model?.name
                }
                .write { context.model?.name = $1.input },
            
            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .write { context.model?.key = $1.input }
                .read { $1.output.value = context.model?.key },
            
            TextareaField(key: "value")
                .read { $1.output.value = context.model?.value }
                .write { context.model?.value = $1.input },
            
            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },
        ]
    }
}
