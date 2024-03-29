//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

final class UserRolePermissionModel: FeatherDatabaseModel {
    typealias Module = UserModule
    
    static var featherIdentifier: String = "role_permissions"
    
    struct FieldKeys {
        struct v1 {
            static var roleId: FieldKey { "role_id" }
            static var permissionId: FieldKey { "permission_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.roleId) var role: UserRoleModel
    @Parent(key: FieldKeys.v1.permissionId) var permission: UserPermissionModel

    init() {}

    init(roleId: UUID, permissionId: UUID) {
        self.$role.id = roleId
        self.$permission.id = permissionId
    }
}

