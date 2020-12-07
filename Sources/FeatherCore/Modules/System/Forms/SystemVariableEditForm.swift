//
//  SystemVariableEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

final class SystemVariableEditForm: ModelForm {
    typealias Model = SystemVariableModel

    struct Input: Decodable {
        var modelId: UUID?
        var key: String
        var name: String
        var value: String
        var notes: String
    }

    var modelId: UUID?
    var key = FormField<String>(key: "key").required().length(max: 250)
    var name = FormField<String>(key: "name").required().length(max: 250)
    var value = FormField<String>(key: "value")
    var notes = FormField<String>(key: "notes")
    var notification: String?

    var fields: [AbstractFormField] {
        [key, name, value, notes]
    }

    init() {}
    
    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        name.value = context.name
        key.value = context.key
        value.value = context.value
        notes.value = context.notes
        return req.eventLoop.future()
    }
    
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        SystemVariableModel.find(key: key.value!, db: req.db).map { [unowned self] model in
            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
                key.error = "Key is already in use"
                return false
            }
            return true
        }
    }

    func read(from input: Model)  {
        modelId = input.id
        key.value = input.key
        name.value = input.name
        value.value = input.value
        notes.value = input.notes
    }

    func write(to output: Model) {
        output.key = key.value!
        output.name = name.value!
        output.value = value.value?.emptyToNil
        output.notes = notes.value?.emptyToNil
    }
}

