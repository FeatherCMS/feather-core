//
//  UserRoleModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class SystemRoleModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name = "roles"

    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var name: FieldKey { "name" }
        static var notes: FieldKey { "notes" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the model
    @ID() var id: UUID?
    /// name of the permission
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.notes) var notes: String?
    
    /// users relation
    @Siblings(through: FeatherUserRoleModel.self, from: \.$role, to: \.$user) var users: [SystemUserModel]
    
    /// permission relation
    @Siblings(through: FeatherRolePermissionModel.self, from: \.$role, to: \.$permission) var permissions: [SystemPermissionModel]

    init() { }
    
    init(id: UUID? = nil, key: String, name: String, notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}



extension SystemRoleModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: name)
    }
}


// MARK: - api

extension SystemRoleModel {

    var listContent: RoleListObject {
        .init(id: id!, name: name)
    }

    var getContent: RoleGetObject {
        .init(id: id!, key: key, name: name, notes: notes)
    }

    func create(_ input: RoleCreateObject) throws {
        key = input.key
        name = input.name
        notes = input.notes
    }

    func update(_ input: RoleUpdateObject) throws {
        key = input.key
        name = input.name
        notes = input.notes
    }

    func patch(_ input: RolePatchObject) throws {
        key = input.key ?? key
        name = input.name ?? name
        notes = input.notes ?? notes
    }
}


// MARK: - api validation


extension RoleListObject: Content {}
extension RoleGetObject: Content {}
extension RoleCreateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension RoleUpdateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension RolePatchObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

// MARK: - helpers

extension SystemRoleModel {
    
    /// find role with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<SystemRoleModel?> {
        SystemRoleModel.query(on: db).filter(\.$id == id).with(\.$permissions).first()
    }
}


