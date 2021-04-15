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

extension SystemRoleModel {
    
    /// find role with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<SystemRoleModel?> {
        SystemRoleModel.query(on: db).filter(\.$id == id).with(\.$permissions).first()
    }
}


