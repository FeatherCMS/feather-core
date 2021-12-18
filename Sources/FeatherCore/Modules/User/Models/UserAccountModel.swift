//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor
import Fluent

final class UserAccountModel: FeatherModel {
    typealias Module = UserModule

    struct FieldKeys {
        struct v1 {
            static var email: FieldKey { "email" }
            static var password: FieldKey { "password" }
            static var isRoot: FieldKey { "is_root" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.email) var email: String
    @Field(key: FieldKeys.v1.password) var password: String
    @Field(key: FieldKeys.v1.isRoot) var isRoot: Bool
    @Siblings(through: UserAccountRoleModel.self, from: \.$user, to: \.$role) var roles: [UserRoleModel]
    
    init() {
        self.isRoot = false
    }

    init(id: UUID? = nil,
         email: String,
         password: String,
         isRoot: Bool = false)
    {
        self.id = id
        self.email = email
        self.password = password
        self.isRoot = isRoot
    }
}

extension UserAccountModel: Authenticatable {
    
    var userAccount: UserAccount {
        return .init(id: uuid, email: email, isRoot: isRoot, roles: roles.map(\.userRole))
    }
}

extension UserAccountModel {

    static func findWithRolesBy(id: UUID, on db: Database) async throws -> UserAccountModel {
        guard let model = try await query(on: db).filter(\.$id == id).with(\.$roles).first() else {
            throw Abort(.notFound)
        }
        return model
    }
    
    static func findWithPermissionsBy(id: UUID, on db: Database) async throws -> UserAccountModel? {
        try await query(on: db)
            .filter(\.$id == id)
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
    }

    static func findWithPermissionsBy(email: String, on db: Database) async throws -> UserAccountModel? {
        try await query(on: db)
            .filter(\.$email == email.lowercased())
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
    }
}



