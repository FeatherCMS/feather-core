//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuEditForm: EditForm {
    typealias Model = SystemMenuModel

    
    var key = TextField(key: "key", required: true)
    var name = TextField(key: "name", required: true)
    var notes = TextField(key: "notes")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [key, name, notes]
    }

    func uniqueKeyValidator(optional: Bool = false) -> ContentValidator<String> {
        return ContentValidator<String>(key: "key", message: "Key must be unique", asyncValidation: { value, req in
            var query = Model.query(on: req.db).filter(\.$key == value)
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
        notes.output.value = input.notes
    }

    func write(to output: Model) {
        output.key = key.input.value!
        output.name = name.input.value!
        output.notes = notes.input.value?.emptyToNil
    }
}
