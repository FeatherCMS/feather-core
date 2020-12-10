//
//  UserRoleModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//


final class UserUserRoleModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "user_roles"
    
    struct FieldKeys {
        static var userId: FieldKey { "user_id" }
        static var roleId: FieldKey { "role_id" }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.userId) var user: UserModel
    @Parent(key: FieldKeys.roleId) var role: UserRoleModel
    
    init() {}

    init(userId: UUID, roleId: UUID) {
        self.$user.id = userId
        self.$role.id = roleId
    }
}
