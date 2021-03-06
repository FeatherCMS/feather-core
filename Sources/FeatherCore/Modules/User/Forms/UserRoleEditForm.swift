//
//  UserRoleEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

    
    
struct UserRoleEditForm: FeatherForm {
    
    var context: FeatherFormContext<UserRoleModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "key")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                    FormFieldValidator($1, "Key must be unique", nil) { field, req in
                        Model.isUniqueBy(\.$key == field.input, req: req)
                    }
                ] }
                .read { $1.output.value = context.model?.key }
                .write { context.model?.key = $1.input },
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator.required($1),
                ] }
                .read { $1.output.value = context.model?.name }
                .write { context.model?.name = $1.input },

            TextareaField(key: "notes")
                .read { $1.output.value = context.model?.notes }
                .write { context.model?.notes = $1.input },
            
            MultiGroupOptionField(key: "permissions")
                .load {  req, field in
                    UserPermissionModel.query(on: req.db)
                        .all()
                        .map { field.output.options = getMultiGroupOptions($0) }
                }
                .read { req, field in
                    field.output.values = context.model?.permissions.compactMap { $0.identifier } ?? []
                }
                .save { req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    return context.model!.$permissions.reAttach(ids: values, on: req.db)
                }
        ]
    }

    private func getMultiGroupOptions(_ permissions: [UserPermissionModel]) -> [FormFieldMultiGroupOption] {
        var data: [FormFieldMultiGroupOption] = []
        for permission in permissions {
            let ffo = FormFieldOption(key: permission.identifier, label: permission.action.capitalized)
            let module = permission.namespace.capitalized

            /// if there is no module with the permission, we create it...
            var moduleIndex: Array<FormFieldMultiGroupOption>.Index!
            if let i = data.firstIndex(where: { $0.name == module }) {
                moduleIndex = i
            }
            else {
                data.append(FormFieldMultiGroupOption(name: module))
                moduleIndex = data.endIndex.advanced(by: -1)
            }

            let ctx = permission.context.replacingOccurrences(of: ".", with: " ").capitalized
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
