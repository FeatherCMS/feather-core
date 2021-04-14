//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//

final class SystemVariableEditForm: EditForm {
    typealias Model = SystemVariableModel

    var modelId: UUID?
    
    var key = TextField(key: "key", required: true)
    var name = TextField(key: "name", required: true)
    var value = TextField(key: "value")
    var notes = TextField(key: "notes")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [key, name, value, notes]
    }

    func uniqueKeyValidator(optional: Bool = false) -> ContentValidator<String> {
        return ContentValidator<String>(key: "key", message: "Key must be unique", asyncValidation: { value, req in
            var query = SystemVariableModel.query(on: req.db).filter(\.$key == value)
            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
                query = query.filter(\.$id != uuid)
            }
            return query.count().map { $0 == 0  }
        })
    }

    init() {
        key.validation.validators.append(uniqueKeyValidator())
    }

    func read(from input: Model)  {
        key.output.value = input.key
        name.output.value = input.name
        value.output.value = input.value
        notes.output.value = input.notes
    }

    func write(to output: Model) {
        output.key = key.input.value!
        output.name = name.input.value!
        output.value = value.input.value?.emptyToNil
        output.notes = notes.input.value?.emptyToNil
    }
}

