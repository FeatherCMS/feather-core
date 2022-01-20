//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

final class UserTokenModel: FeatherDatabaseModel {
    typealias Module = UserModule
        
    struct FieldKeys {
        struct v1 {
            static var value: FieldKey { "value" }
            static var accountId: FieldKey { "account_id" }
        }
    }
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.value) var value: String
    @Parent(key: FieldKeys.v1.accountId) var account: UserAccountModel

    init() { }
    
    init(id: UUID? = nil,
         value: String,
         accountId: UUID)
    {
        self.id = id
        self.value = value
        self.$account.id = accountId
    }
}

//extension UserTokenModel: ModelTokenAuthenticatable {
//    static let valueKey = \UserTokenModel.$value
//    static let userKey = \UserTokenModel.$user
//
//    var isValid: Bool {
//        true
//    }
//}
