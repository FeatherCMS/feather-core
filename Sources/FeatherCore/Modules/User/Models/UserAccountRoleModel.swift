//
//  UserRoleModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserAccountRoleModel: FeatherModel {
    typealias Module = UserModule
    
    static let modelKey: String = "user_roles"
    static let name: FeatherModelName = "User role"
    
    struct FieldKeys {
        static var userId: FieldKey { "user_id" }
        static var roleId: FieldKey { "role_id" }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.userId) var user: UserAccountModel
    @Parent(key: FieldKeys.roleId) var role: UserRoleModel
    
    init() {}

    init(userId: UUID, roleId: UUID) {
        self.$user.id = userId
        self.$role.id = roleId
    }
}
