//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuEditForm: ModelForm<SystemMenuModel> {
    
    override func initialize() {
        super.initialize()

        self.fields = [
            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Key is required") { !$0.input.isEmpty },
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .persist(\.key) { [unowned self] in model },

            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .persist(\.name) { [unowned self] in model },

            TextareaField(key: "notes").persist(\.notes) { [unowned self] in model },
        ]
    }
}
