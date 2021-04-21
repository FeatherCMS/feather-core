//
//  UserRoleModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class FeatherRolePermissionModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name: FeatherModelName = "role_permission"
    
    struct FieldKeys {
        static var roleId: FieldKey { "role_id" }
        static var permissionId: FieldKey { "permission_id" }
        
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.roleId) var role: SystemRoleModel
    @Parent(key: FieldKeys.permissionId) var permission: SystemPermissionModel

    init() {}

    init(roleId: UUID, permissionId: UUID) {
        self.$role.id = roleId
        self.$permission.id = permissionId
    }
}
