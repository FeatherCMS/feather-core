//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct UserRoleEditor: FeatherModelEditor {
    let model: UserRoleModel
    let form: AbstractForm

    init(model: UserRoleModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    var formFields: [FormField] {
        InputField("key")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator($1, "Key must be unique") { req, field in
                    try await Model.isUnique(req, \.$key == field.input, User.Role.getIdParameter(req))
                }
            }
            .read { $1.output.context.value = model.key }
            .write { model.key = $1.input }
        
        InputField("name")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }
        
        TextareaField("notes")
            .read { $1.output.context.value = model.notes }
            .write { model.notes = $1.input }
        
        CheckboxBundleField("permissions")
            .load { req, field in
                let permissions = try await UserPermissionModel.query(on: req.db).all()
                field.output.context.options = getOptionBundles(permissions)
            }
            .read { req, field in
                field.output.context.values = model.permissions.compactMap { $0.uuid.string }
            }
            .save { req, field in
                let values = field.input.compactMap(\.uuid)
                return try await model.$permissions.reAttach(ids: values, on: req.db)
            }
    }
    
    private func getOptionBundles(_ permissions: [UserPermissionModel]) -> [OptionBundleContext] {
        var data: [OptionBundleContext] = []
        for permission in permissions {
            let ffo = OptionContext(key: permission.uuid.string, label: permission.action.capitalized)
            let module = permission.namespace.capitalized

            /// if there is no module with the permission, we create it...
            var moduleIndex: Array<OptionGroupContext>.Index!
            if let i = data.firstIndex(where: { $0.name == module }) {
                moduleIndex = i
            }
            else {
                data.append(OptionBundleContext(name: module))
                moduleIndex = data.endIndex.advanced(by: -1)
            }

            let ctx = permission.context.replacingOccurrences(of: ".", with: " ").capitalized
            /// find an existing ctx group or create a new one...
            var groupIndex: Array<OptionGroupContext>.Index!
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
