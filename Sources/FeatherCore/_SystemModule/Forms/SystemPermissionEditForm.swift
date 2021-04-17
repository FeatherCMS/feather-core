//
//  UserPermissionEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class SystemPermissionEditForm: ModelForm<SystemPermissionModel> {

//    var namespace = TextField(key: "namespace", required: true)
//    var context = TextField(key: "context", required: true)
//    var action = TextField(key: "action", required: true)
//    var name = TextField(key: "name", required: true)
//    var notes = TextareaField(key: "notes")
//    var notification: String?
//
//    var fields: [FormFieldRepresentable] {
//        [namespace, context, action, name, notes]
//    }
//
//    func uniqueKeyValidator(optional: Bool = false) -> ContentValidator<String> {
//        return ContentValidator<String>(key: "namespace", message: "Permission must be unique", asyncValidation: { [unowned self] value, req in
//            var query = SystemPermissionModel.query(on: req.db)
//                .filter(\.$namespace == namespace.input.value!)
//                .filter(\.$context == context.input.value!)
//                .filter(\.$action == action.input.value!)
//
//            if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
//                query = query.filter(\.$id != uuid)
//            }
//            return query.count().map { $0 == 0  }
//        })
//    }
//
//    init() {
//        namespace.validation.validators.append(uniqueKeyValidator())
//    }
//
//    func read(from input: Model)  {
//        namespace.output.value = input.namespace
//        context.output.value = input.context
//        action.output.value = input.action
//        name.output.value = input.name
//        notes.output.value = input.notes
//    }
//
//    func write(to output: Model) {
//        output.namespace = namespace.input.value!
//        output.context = context.input.value!
//        output.action = action.input.value!
//        output.name = name.input.value!
//        output.notes = notes.input.value?.emptyToNil
//    }
}
