//
//  UserTokenModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

final class UserTokenModel: FeatherModel {
    typealias Module = UserModule
    
    static let modelKey: String = "tokens"
    static let name: FeatherModelName = "Token"
    static let schema = "\(Module.moduleKey)_user_\(modelKey)"
    
    struct FieldKeys {
        static var value: FieldKey { "value" }
        static var userId: FieldKey { "user_id" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the token
    @ID() var id: UUID?
    /// value of the token string
    @Field(key: FieldKeys.value) var value: String
    /// associated user object to the token
    @Parent(key: FieldKeys.userId) var user: UserAccountModel

    init() { }
    
    init(id: UUID? = nil,
         value: String,
         userId: UUID)
    {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

// MARK: - auth

/// users can be authenticated using a Bearer token
extension UserTokenModel: ModelTokenAuthenticatable {
    static let valueKey = \UserTokenModel.$value
    static let userKey = \UserTokenModel.$user
    
    var isValid: Bool {
        true
    }
}

// MARK: - api

extension UserTokenModel {

    var getContent: TokenObject {
        .init(id: id!, value: value, userId: $user.id)
    }
}

extension TokenObject: Content {}
