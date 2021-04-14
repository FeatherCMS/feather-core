//
//  UserPermissionEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class SystemPermissionEditForm: EditForm {
    typealias Model = SystemPermissionModel

    var modelId: UUID?
    var namespace = TextField(key: "namespace", required: true)
    var context = TextField(key: "context", required: true)
    var action = TextField(key: "action", required: true)
    var name = TextField(key: "name", required: true)
    var notes = TextareaField(key: "notes")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [namespace, context, action, name, notes]
    }

    init() {}
    
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        SystemPermissionModel.query(on: req.db)
            .filter(\.$namespace == namespace.input.value!)
            .filter(\.$context == context.input.value!)
            .filter(\.$action == action.input.value!)
            .first()
            .map { [unowned self] model -> Bool in
                if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
                    namespace.output.error = "This combination is already in use"
                    context.output.error = namespace.output.error
                    action.output.error = namespace.output.error
                    return false
                }
                return true
            }
    }

    func read(from input: Model)  {
        namespace.output.value = input.namespace
        context.output.value = input.context
        action.output.value = input.action
        name.output.value = input.name
        notes.output.value = input.notes
    }

    func write(to output: Model) {
        output.namespace = namespace.input.value!
        output.context = context.input.value!
        output.action = action.input.value!
        output.name = name.input.value!
        output.notes = notes.input.value?.emptyToNil
    }
}
