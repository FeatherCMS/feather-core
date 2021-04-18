//
//  UserRoleEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//


final class SystemRoleEditForm: ModelForm<SystemRoleModel> {

    override func initialize() {
        super.initialize()
        
        self.fields = [
            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Key is required") { !$0.input.isEmpty },
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .read { [unowned self] in $1.output.value = model?.key }
                .write { [unowned self] in model?.key = $1.input },
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { [unowned self] in $1.output.value = model?.name }
                .write { [unowned self] in model?.name = $1.input },

            TextareaField(key: "notes")
                .read { [unowned self] in $1.output.value = model?.notes }
                .write { [unowned self] in model?.notes = $1.input },
            
            MultiGroupOptionField(key: "permissions")
                .load { [unowned self] req, field in
                    SystemPermissionModel.query(on: req.db)
                        .all()
                        .map { field.output.options = getMultiGroupOptions($0) }
                }
                .read { [unowned self] req, field in
                    field.output.values = model?.permissions.compactMap { $0.identifier } ?? []
                }
                .save { [unowned self] req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    #warning("generic diff for attach / detach")
//                    print(model?.permissions.map(\.id!.uuidString))
//                    print(req.body.data!.getString(at: 0, length: req.body.data!.readableBytes))
                    return model!.$permissions.detach(model!.permissions, on: req.db).flatMap {
                        SystemPermissionModel.query(on: req.db).filter(\.$id ~~ values).all().flatMap { items in
                            model!.$permissions.attach(items, on: req.db)
                        }
                    }
                }
        ]
    }

    private func getMultiGroupOptions(_ permissions: [SystemPermissionModel]) -> [FormFieldMultiGroupOption] {
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
        return data
    }
}
