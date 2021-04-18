//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//

final class SystemVariableEditForm: ModelForm<SystemVariableModel> {

    override func initialize() {

        self.fields = [
            TextField(key: "name")
                .config {
                    $0.output.required = true
                }
                .validators { req, field in
                    [
                        FormFieldValidator(field, "Name is required") { !$0.input.isEmpty },
                    ]
                }
                .persist(\.name) { [unowned self] in model },
            
            TextField(key: "key")
                .config {
                    $0.output.required = true
                }
                .validators { req, field in
                    [
                        FormFieldValidator(field, "Key is required") { !$0.input.isEmpty },
                        FormFieldValidator(field, "Key must be unique", nil) { field, req in
                            var query = SystemVariableModel.query(on: req.db).filter(\.$key == field.input)
                            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
                                query = query.filter(\.$id != uuid)
                            }
                            return query.count().map { $0 == 0  }
                        }
                    ]
                }
                .persist(\.key) { [unowned self] in model },
            
            TextareaField(key: "value").persist(\.value) { [unowned self] in model },
            TextareaField(key: "notes").persist(\.notes) { [unowned self] in model },
        ]
    }
}

