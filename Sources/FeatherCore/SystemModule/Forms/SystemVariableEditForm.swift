//
//  SystemVariableEditForm.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//
//

final class SystemVariableEditForm: ModelForm {
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

    init() {}
    
//    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
//        SystemVariableModel.query(on: req.db).filter(\.$key == key.value!).first().map { [unowned self] model in
//            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
//                key.error = "Key is already in use"
//                return false
//            }
//            return true
//        }
//    }

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

