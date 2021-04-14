//
//  UserRoleEditForm.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

//#warning("move these out somewhere else...")
//struct ModulePermission: TemplateDataRepresentable {
//
//    struct Group: TemplateDataRepresentable {
//
//        var name: String
//        var permissions: [FormFieldOption]
//
//        var templateData: TemplateData {
//            .dictionary([
//                "name": name,
//                "permissions": permissions.map(\.templateData),
//            ])
//        }
//    }
//
//    var module: String
//    var groups: [Group]
//
//    var templateData: TemplateData {
//        .dictionary([
//            "module": module,
//            "groups": groups.map(\.templateData),
//        ])
//    }
//}
//
//final class PermissionFormField: FormFieldRepresentable {
//
//    var key: String
//    var name: String?
//    var error: String?
//    var values: [UUID]
//    var options: [ModulePermission]
//
//    init(key: String,
//                values: [UUID] = [],
//                options: [ModulePermission] = [],
//                name: String? = nil,
//                error: String? = nil)
//    {
//        self.key = key
//        self.values = values
//        self.options = options
//        self.name = name
//
//        self.error = error
//    }
//
//    var templateData: TemplateData {
//        .dictionary([
//            "key": key,
//            "name": name,
//            "values": values,
//            "options": options.map(\.templateData),
//            "error": error,
//        ])
//    }
//
//    func validate() -> Bool { true }
//
//    func set(_ permissions: [SystemPermissionModel]) {
//
//        var data: [ModulePermission] = []
//        for permission in permissions {
//            let ffo = FormFieldOption(key: permission.id!.uuidString, label: permission.action.capitalized)
//            let module = permission.namespace.lowercased().capitalized
//
//            /// if there is no module with the permission, we create it...
//            var moduleIndex: Array<ModulePermission>.Index!
//            if let i = data.firstIndex(where: { $0.module == module }) {
//                moduleIndex = i
//            }
//            else {
//                data.append(ModulePermission(module: module, groups: []))
//                moduleIndex = data.endIndex.advanced(by: -1)
//            }
//
//            let ctx = permission.context.replacingOccurrences(of: ".", with: " ").lowercased().capitalized
//            /// find an existing ctx group or create a new one...
//            var groupIndex: Array<ModulePermission.Group>.Index!
//            if let g = data[moduleIndex].groups.firstIndex(where: { $0.name == ctx }) {
//                groupIndex = g
//            }
//            else {
//                data[moduleIndex].groups.append(.init(name: ctx, permissions: []))
//                groupIndex = data[moduleIndex].groups.endIndex.advanced(by: -1)
//            }
//            data[moduleIndex].groups[groupIndex].permissions.append(ffo)
//        }
//        options = data
//    }
//
//    func process(req: Request) {
//        values = (try? req.content.get([UUID].self, at: key)) ?? []
//    }
//}
//
//final class SystemRoleEditForm: ModelForm {
//    typealias Model = SystemRoleModel
//
//    var modelId: UUID?
//    var key = FormField<String>(key: "key").required().length(max: 250)
//    var name = FormField<String>(key: "name").required().length(max: 250)
//    var notes = FormField<String>(key: "notes").length(max: 250)
//    var permissions = PermissionFormField(key: "permissions")
//    var notification: String?
//    
//    var fields: [FormFieldRepresentable] {
//        [key, name, notes, permissions]
//    }
//
//    init() {}
//
//    func initialize(req: Request) -> EventLoopFuture<Void> {
//        SystemPermissionModel.query(on: req.db)
//            .all()
//            .map { [unowned self] in permissions.set($0) }
//    }
//
//    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
//        SystemRoleModel.query(on: req.db).filter(\.$key == key.value!).first().map { [unowned self] model -> Bool in
//            if (modelId == nil && model != nil) || (modelId != nil && model != nil && modelId! != model!.id) {
//                key.error = "Key is already in use"
//                return false
//            }
//            return true
//        }
//    }
//    
//    func read(from input: Model)  {
//        key.value = input.key
//        name.value = input.name
//        notes.value = input.notes
//        permissions.values = input.permissions.compactMap { $0.id }
//    }
//
//    func write(to output: Model) {
//        output.key = key.value!
//        output.name = name.value!
//        output.notes = notes.value?.emptyToNil
//    }
//    
//    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
//        var future = req.eventLoop.future()
//        if modelId != nil {
//            future = FeatherRolePermissionModel.query(on: req.db).filter(\.$role.$id == model.id!).delete()
//        }
//        return future.flatMap { [unowned self] in
//            permissions.values.map { FeatherRolePermissionModel(roleId: model.id!, permissionId: $0) }.create(on: req.db)
//        }
//    }
//}
