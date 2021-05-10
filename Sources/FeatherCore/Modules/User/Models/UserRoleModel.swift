//
//  UserRoleModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserRoleModel: FeatherModel {
    typealias Module = UserModule
    
    static let modelKey: String = "roles"
    static let name: FeatherModelName = "Role"

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
    @OptionalField(key: FieldKeys.notes) var notes: String?
    
    /// users relation
    @Siblings(through: UserAccountRoleModel.self, from: \.$role, to: \.$user) var users: [UserAccountModel]
    
    /// permission relation
    @Siblings(through: UserRolePermissionModel.self, from: \.$role, to: \.$permission) var permissions: [UserPermissionModel]

    init() { }
    
    init(id: UUID? = nil, key: String, name: String, notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}

extension UserRoleModel {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: name)
    }
}

extension UserRoleModel {
    
    /// find role with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<UserRoleModel?> {
        UserRoleModel.query(on: db).filter(\.$id == id).with(\.$permissions).first()
    }
}


