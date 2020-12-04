//
//  MenuEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class MenuEditForm: ModelForm<MenuModel> {

    struct Input: Decodable {
        var modelId: UUID?
        var key: String
        var name: String
        var notes: String
    }

    var key = FormField<String>(key: "key").required().length(max: 250)
    var name = FormField<String>(key: "name").length(max: 250)
    var notes = FormField<String>(key: "notes").length(max: 250)
        
    required init() {
        super.init()
    }

    required init(req: Request) throws {
        try super.init(req: req)
        
        let context = try req.content.decode(Input.self)
        modelId = context.modelId
        key.value = context.key
        name.value = context.name
        notes.value = context.notes
    }

    override func fields() -> [FormFieldInterface] {
        [key, name, notes]
    }

    override func read(from input: Model)  {
        modelId = input.id
        key.value = input.key
        name.value = input.name
        notes.value = input.notes
    }

    override func write(to output: Model) {
        output.key = key.value!
        output.name = name.value?.emptyToNil
        output.notes = notes.value?.emptyToNil
    }
}
