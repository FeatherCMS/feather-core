//
//  UserModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "users"

    struct FieldKeys {
        
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
        static var root: FieldKey { "root" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the model
    @ID() var id: UUID?
    /// email address of the user
    @Field(key: FieldKeys.email) var email: String
    /// hashed password of the user
    @Field(key: FieldKeys.password) var password: String
    /// is the user root user
    @Field(key: FieldKeys.root) var root: Bool

    @Siblings(through: UserUserRoleModel.self, from: \.$user, to: \.$role) var roles: [UserRoleModel]
    
    var permissions: [String] = []

    init() { }
    
    init(id: UserModel.IDValue? = nil,
         email: String,
         password: String,
         root: Bool = false)
    {
        self.id = id
        self.email = email
        self.password = password
        self.root = root
    }
}

