//
//  UserModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserAccountModel: FeatherModel {
    typealias Module = UserModule
    
    static let modelKey: String = "users"
    static let name: FeatherModelName = "User"

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

    @Siblings(through: UserAccountRoleModel.self, from: \.$user, to: \.$role) var roles: [UserRoleModel]

    init() { }
    
    init(id: UUID? = nil,
         email: String,
         password: String,
         root: Bool = false)
    {
        self.id = id
        self.email = email
        self.password = password
        self.root = root
    }
    
    // MARK: - query
       
    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.email,
        ]
    }
    
    static func defaultSort() -> FieldSort {
        .asc
    }

    static func search(_ term: String) -> [ModelValueFilter<UserAccountModel>] {
        [
            \.$email ~~ term,
        ]
    }
}

extension UserAccountModel {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: email)
    }
}

extension UserAccountModel: Authenticatable {
    
    var aclObject: User {
        User(id: id!, email: email, isRoot: root, permissions: roles.reduce([]) { $0 + $1.permissions.map(\.aclObject) })
    }
}

extension UserAccountModel {

    /// find user by identifier with roles
    static func findWithRolesBy(id: UUID, on db: Database) -> EventLoopFuture<UserAccountModel?> {
        query(on: db).filter(\.$id == id).with(\.$roles).first()
    }
    
    /// find user by identifier with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<UserAccountModel?> {
        query(on: db)
            .filter(\.$id == id)
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
    }

    /// find user email with permissions
    static func findWithPermissionsBy(email: String, on db: Database) -> EventLoopFuture<UserAccountModel?> {
        query(on: db)
            .filter(\.$email == email.lowercased())
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
    }
}


