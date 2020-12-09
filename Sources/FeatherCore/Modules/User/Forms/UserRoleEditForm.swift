//
//  UserRoleEditForm.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

final class UserRoleEditForm: ModelForm {
    typealias Model = UserRoleModel

    var modelId: UUID?
    var key = FormField<String>(key: "key").required().length(max: 250)
    var name = FormField<String>(key: "name").required().length(max: 250)
    var notes = FormField<String>(key: "notes").length(max: 250)
    var permissions = ArraySelectionFormField<UUID>(key: "permissions")
    var notification: String?
    
    var fields: [FormFieldRepresentable] {
        [key, name, notes, permissions]
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        UserPermissionModel.query(on: req.db)
            .sort(\.$name)
            .all()
            .mapEach(\.formFieldOption)
            .map { [unowned self] in permissions.options = $0 }
    }
    
    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        UserRoleModel.query(on: req.db).filter(\.$key == key.value!).first().map { [unowned self] model -> Bool in
            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
                key.error = "Key is already in use"
                return false
            }
            return true
        }
    }
    
    func read(from input: Model)  {
        key.value = input.key
        name.value = input.name
        notes.value = input.notes
        permissions.values = input.permissions.compactMap { $0.id }
    }

    func write(to output: Model) {
        output.key = key.value!
        output.name = name.value!
        output.notes = notes.value?.emptyToNil
    }
    
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if modelId != nil {
            future = UserRolePermissionModel.query(on: req.db).filter(\.$role.$id == model.id!).delete()
        }
        return future.flatMap { [unowned self] in
            permissions.values.map { UserRolePermissionModel(roleId: model.id!, permissionId: $0) }.create(on: req.db)
        }
    }
}
