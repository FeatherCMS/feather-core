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
            static var accountId: FieldKey { "account_id" }
            static var roleId: FieldKey { "role_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.accountId) var account: UserAccountModel
    @Parent(key: FieldKeys.v1.roleId) var role: UserRoleModel
    
    init() {}

    init(accountId: UUID, roleId: UUID) {
        self.$account.id = accountId
        self.$role.id = roleId
    }
}
