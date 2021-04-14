//
//  UserPermissionModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class SystemPermissionModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name = "permissions"

    struct FieldKeys {
        static var namespace: FieldKey { "namespace" }
        static var context: FieldKey { "context" }
        static var action: FieldKey { "action" }
        static var name: FieldKey { "name" }
        static var notes: FieldKey { "notes" }
    }
    
    // MARK: - fields

    /// unique identifier of the model
    @ID() var id: UUID?
    /// name of the permission
    @Field(key: FieldKeys.namespace) var namespace: String
    @Field(key: FieldKeys.context) var context: String
    @Field(key: FieldKeys.action) var action: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.notes) var notes: String?
    
    /// permission relation
    @Siblings(through: FeatherRolePermissionModel.self, from: \.$permission, to: \.$role) var roles: [SystemRoleModel]
    
    init() { }

    init(id: UUID? = nil,
         namespace: String,
         context: String,
         action: String,
         name: String,
         notes: String? = nil) {
        self.id = id
        self.namespace = namespace
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.namespace,
            FieldKeys.context,
            FieldKeys.action,
            FieldKeys.name,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<SystemPermissionModel>] {
        [
            \.$namespace ~~ term,
            \.$action ~~ term,
            \.$context ~~ term,
            \.$name ~~ term,
            \.$notes ~~ term,
        ]
    }
}

extension SystemPermissionModel {
    var key: String { [namespace, context, action].joined(separator: ".") }
}

// MARK: - view

extension SystemPermissionModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "key": key,
            "module": namespace,
            "context": context,
            "action": action,
            "name": name,
            "notes": notes,
        ])
    }
}

extension SystemPermissionModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: name)
    }
}


// MARK: - api

extension SystemPermissionModel: ApiContentRepresentable {

    var listContent: PermissionListObject {
        .init(id: id!, name: name)
    }

    var getContent: PermissionGetObject {
        .init(id: id!, module: namespace, context: context, action: action, name: name, notes: notes)
    }

    func create(_ input: PermissionCreateObject) throws {
        namespace = input.module
        context = input.context
        action = input.action
        name = input.name
        notes = input.notes
    }

    func update(_ input: PermissionUpdateObject) throws {
        namespace = input.module
        context = input.context
        action = input.action
        name = input.name
        notes = input.notes
    }

    func patch(_ input: PermissionPatchObject) throws {
        namespace = input.module ?? namespace
        context = input.context ?? context
        action = input.action ?? action
        name = input.name ?? name
        notes = input.notes ?? notes
    }
}


// MARK: - api validation


extension PermissionListObject: Content {}
extension PermissionGetObject: Content {}
extension PermissionCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250))
        validations.add("context", as: String.self, is: !.empty && .count(...250))
        validations.add("action", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension PermissionUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250))
        validations.add("context", as: String.self, is: !.empty && .count(...250))
        validations.add("action", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension PermissionPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("context", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("action", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

