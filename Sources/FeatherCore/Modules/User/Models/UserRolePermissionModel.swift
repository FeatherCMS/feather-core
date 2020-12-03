//
//  UserRoleModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//


final class UserRolePermissionModel: ViperModel {
    

    typealias Module = UserModule
    
    static let name = "role_permission"
    
    struct FieldKeys {
        static var roleId: FieldKey { "role_id" }
        static var permissionId: FieldKey { "permission_id" }
        
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.roleId) var role: UserRoleModel
    @Parent(key: FieldKeys.permissionId) var permission: UserPermissionModel

    init() {}

    init(roleId: UUID, permissionId: UUID) {
        self.$role.id = roleId
        self.$permission.id = permissionId
    }
}
