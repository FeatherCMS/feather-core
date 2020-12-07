//
//  MenuEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class FrontendMenuEditForm: ModelForm {
    typealias Model = FrontendMenuModel

    struct Input: Decodable {
        var modelId: UUID?
        var key: String
        var name: String
        var notes: String
    }

    var modelId: UUID?
    var key = FormField<String>(key: "key").required().length(max: 250)
    var name = FormField<String>(key: "name").required().length(max: 250)
    var notes = FormField<String>(key: "notes").length(max: 250)
    var notification: String?

    var fields: [AbstractFormField] {
        [key, name, notes]
    }

    init() {}

    func processInput(req: Request) throws -> EventLoopFuture<Void> {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        key.value = context.key
        name.value = context.name
        notes.value = context.notes
        return req.eventLoop.future()
    }
    
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        FrontendMenuModel.query(on: req.db).filter(\.$key == key.value!).first().map { [unowned self] model -> Bool in
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
        notes.value = input.notes
    }

    func write(to output: Model) {
        output.key = key.value!
        output.name = name.value!
        output.notes = notes.value?.emptyToNil
    }
}
