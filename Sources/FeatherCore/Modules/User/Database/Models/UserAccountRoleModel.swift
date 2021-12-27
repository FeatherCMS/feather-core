//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

final class UserAccountRoleModel: FeatherDatabaseModel {
    typealias Module = UserModule
    
    static var featherIdentifier: String = "account_roles"
    
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var roleId: FieldKey { "role_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.userId) var user: UserAccountModel
    @Parent(key: FieldKeys.v1.roleId) var role: UserRoleModel
    
    init() {}

    init(userId: UUID, roleId: UUID) {
        self.$user.id = userId
        self.$role.id = roleId
    }
}
