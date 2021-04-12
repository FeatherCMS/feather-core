//
//  UserRoleModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class FeatherUserRoleModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name = "user_roles"
    
    struct FieldKeys {
        static var userId: FieldKey { "user_id" }
        static var roleId: FieldKey { "role_id" }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.userId) var user: SystemUserModel
    @Parent(key: FieldKeys.roleId) var role: SystemRoleModel
    
    init() {}

    init(userId: UUID, roleId: UUID) {
        self.$user.id = userId
        self.$role.id = roleId
    }
}
