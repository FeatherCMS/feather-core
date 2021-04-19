//
//  UserTokenModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

final class SystemTokenModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name = "tokens"
    static let schema = "\(Module.name)_user_\(name)"
    
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
    @Parent(key: FieldKeys.userId) var user: SystemUserModel

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
extension SystemTokenModel: ModelTokenAuthenticatable {
    static let valueKey = \SystemTokenModel.$value
    static let userKey = \SystemTokenModel.$user
    
    var isValid: Bool {
        true
    }
}

// MARK: - api

extension SystemTokenModel {

    var getContent: TokenObject {
        .init(id: id!, value: value, userId: $user.id)
    }
}

extension TokenObject: Content {}
