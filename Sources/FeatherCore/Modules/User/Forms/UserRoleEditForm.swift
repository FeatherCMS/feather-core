//
//  UserRoleEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class UserRoleEditForm: ModelForm {

    typealias Model = UserRoleModel

    struct Input: Decodable {
        var modelId: String
        var key: String
        var name: String
        var notes: String
        var permissions: [String]
    }

    var modelId: String? = nil
    var key = StringFormField()
    var name = StringFormField()
    var notes = StringFormField()
    var permissions = StringArraySelectionFormField()
    var notification: String?
    
    var leafData: LeafData {
        .dictionary([
            "modelId": modelId,
            "key": key,
            "name": name,
            "notes": notes,
            "permissions": permissions,
            "notification": notification,
        ])
    }

    init() {}

    init(req: Request) throws {
        let context = try req.content.decode(Input.self)
        modelId = context.modelId.emptyToNil
        key.value = context.key
        name.value = context.name
        notes.value = context.notes
        permissions.values = context.permissions
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        var valid = true

        if key.value.isEmpty {
            key.error = "Key is required"
            valid = false
        }
        if Validator.count(...250).validate(key.value).isFailure {
            key.error = "Key is too long (max 250 characters)"
            valid = false
        }
        if Validator.count(...250).validate(name.value).isFailure {
            name.error = "Key is too long (max 250 characters)"
            valid = false
        }
        if Validator.count(...250).validate(notes.value).isFailure {
            notes.error = "Key is too long (max 250 characters)"
            valid = false
        }
        /// NOTE: validate permission ids
        return req.eventLoop.future(valid)
    }

    func read(from input: Model)  {
        modelId = input.id?.uuidString
        key.value = input.key
        name.value = input.name ?? ""
        notes.value = input.notes ?? ""
        permissions.values = input.permissions.map { $0.id!.uuidString }
    }

    func write(to output: Model) {
        output.key = key.value
        output.name = name.value.emptyToNil
        output.notes = notes.value.emptyToNil
    }
}
