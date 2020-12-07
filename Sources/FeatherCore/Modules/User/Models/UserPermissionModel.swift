//
//  UserPermissionModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserPermissionModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "permissions"

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
    
    /// permission relation
    @Siblings(through: UserRolePermissionModel.self, from: \.$permission, to: \.$role) var roles: [UserRoleModel]
    
    init() { }

    init(id: UUID? = nil, key: String, name: String, notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}

