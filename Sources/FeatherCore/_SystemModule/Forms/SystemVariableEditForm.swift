//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//

final class SystemVariableEditForm: ModelForm<SystemVariableModel> {

    override func initialize() {
        super.initialize()

        self.fields = [
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.name }
                .write { [unowned self] in model?.name = $1.input },

            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Key is required") { !$0.input.isEmpty },
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .write { [unowned self] in model?.key = $1.input }
                .read { [unowned self] in $1.output.value = model?.key },
            
            TextareaField(key: "value")
                .read { [unowned self] in $1.output.value = model?.value }
                .write { [unowned self] in model?.value = $1.input },
            
            TextareaField(key: "notes")
                .read { [unowned self] in $1.output.value = model?.notes }
                .write { [unowned self] in model?.notes = $1.input },
        ]
    }
}
