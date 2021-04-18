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
                .onValidation { req, field in
                    InputValidator([
                        FormFieldValidator(field, "Name is required") { !$0.input.isEmpty },
                    ]).validate(req)
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.name
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.name = field.input
                    return req.eventLoop.future()
                },
            
            TextField(key: "key")
                .config {
                    $0.output.required = true
                }
                .onValidation { req, field in
                    InputValidator([
                        FormFieldValidator(field, "Key is required") { !$0.input.isEmpty },
                        FormFieldValidator(field, "Key must be unique", nil) { field, req in
                            var query = SystemVariableModel.query(on: req.db).filter(\.$key == field.input)
                            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
                                query = query.filter(\.$id != uuid)
                            }
                            return query.count().map { $0 == 0  }
                        }
                    ]).validate(req)
                }
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.key
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.key = field.input
                    return req.eventLoop.future()
                },
            
            TextareaField(key: "value")
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.value
                    return req.eventLoop.future()
                }
                .onSave { [unowned self] req, field in
                    model?.value = field.input
                    return req.eventLoop.future()
                },
            
            TextareaField(key: "notes")
                .onLoad { [unowned self] req, field in
                    field.output.value = model?.notes
                    return req.eventLoop.future()
                }
                .onSave { [unowned self ] req, field in
                    model?.notes = field.input
                    return req.eventLoop.future()
                },
            
        ]
    }
}

