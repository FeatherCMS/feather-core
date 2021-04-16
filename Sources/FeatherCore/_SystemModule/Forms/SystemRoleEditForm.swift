//
//  UserRoleEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//


final class SystemRoleEditForm: EditForm {
    typealias Model = SystemRoleModel

    var key = TextField(key: "key")
    var name = TextField(key: "name")
    var notes = TextareaField(key: "notes")
    var permissions = MultiGroupOptionField(key: "permissions")
    var notification: String?
    
    var fields: [FormFieldRepresentable] {
        [key, name, notes, permissions]
    }

    // MARK: - helper
    
    private func set(_ permissions: [SystemPermissionModel]) {
        var data: [FormFieldMultiGroupOption] = []
        for permission in permissions {
            let ffo = FormFieldOption(key: permission.identifier, label: permission.action.capitalized)
            let module = permission.namespace.lowercased().capitalized

            /// if there is no module with the permission, we create it...
            var moduleIndex: Array<FormFieldMultiGroupOption>.Index!
            if let i = data.firstIndex(where: { $0.name == module }) {
                moduleIndex = i
            }
            else {
                data.append(FormFieldMultiGroupOption(name: module))
                moduleIndex = data.endIndex.advanced(by: -1)
            }

            let ctx = permission.context.replacingOccurrences(of: ".", with: " ").lowercased().capitalized
            /// find an existing ctx group or create a new one...
            var groupIndex: Array<FormFieldOptionGroup>.Index!
            if let g = data[moduleIndex].groups.firstIndex(where: { $0.name == ctx }) {
                groupIndex = g
            }
            else {
                data[moduleIndex].groups.append(.init(name: ctx))
                groupIndex = data[moduleIndex].groups.endIndex.advanced(by: -1)
            }
            data[moduleIndex].groups[groupIndex].options.append(ffo)
        }
        self.permissions.output.options = data
    }

    func initialize(req: Request) -> EventLoopFuture<Void> {
        SystemPermissionModel.query(on: req.db)
            .all()
            .map { [unowned self] in set($0) }
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
        permissions.output.values = input.permissions.compactMap { $0.identifier }
    }

    func write(to output: Model) {
        output.key = key.input.value!
        output.name = name.input.value!
        output.notes = notes.input.value?.emptyToNil
    }
    
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) {
            future = FeatherRolePermissionModel.query(on: req.db).filter(\.$role.$id == uuid).delete()
        }
        return future.flatMap { [unowned self] in
            #warning("fixme")
            return (permissions.input.value ?? []).compactMap { UUID(uuidString: $0) }.map { FeatherRolePermissionModel(roleId: model.id!, permissionId: $0) }.create(on: req.db)
        }
    }
}
