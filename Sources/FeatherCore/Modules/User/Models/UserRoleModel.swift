//
//  UserRoleModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserRoleModel: ViperModel {
    typealias Module = UserModule
    
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
    @Field(key: FieldKeys.name) var name: String?
    @Field(key: FieldKeys.notes) var notes: String?
    
    /// users relation
    @Siblings(through: UserUserRoleModel.self, from: \.$role, to: \.$user) var users: [UserModel]
    
    /// permission relation
    @Siblings(through: UserRolePermissionModel.self, from: \.$role, to: \.$permission) var permissions: [UserPermissionModel]

    init() { }
    
    init(id: UUID? = nil, key: String, name: String? = nil, notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}

