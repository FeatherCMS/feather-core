//
//  MenuEditForm.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuEditForm: EditForm {
    typealias Model = SystemMenuModel

    var modelId: UUID?
    var key = TextField(key: "key", required: true)
    var name = TextField(key: "name", required: true)
    var notes = TextField(key: "notes")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [key, name, notes]
    }

    init() {}
    
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        SystemMenuModel.query(on: req.db).filter(\.$key == key.input.value!).first().map { [unowned self] model -> Bool in
            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
                key.output.error = "Key is already in use"
                return false
            }
            return true
        }
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
