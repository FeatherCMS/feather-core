//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

final class UserRoleModel: FeatherModel {
    typealias Module = UserModule
    
    struct FieldKeys {
        struct v1 {
            static var key: FieldKey { "key" }
            static var name: FieldKey { "name" }
            static var notes: FieldKey { "notes" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.key) var key: String
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.notes) var notes: String?
    @Siblings(through: UserAccountRoleModel.self, from: \.$role, to: \.$user) var users: [UserAccountModel]
    @Siblings(through: UserRolePermissionModel.self, from: \.$role, to: \.$permission) var permissions: [UserPermissionModel]

    init() { }
    
    init(id: UUID? = nil, key: String, name: String, notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}

extension UserRoleModel {
    
    static func findWithPermissionsBy(id: UUID, on db: Database) async throws -> UserRoleModel? {
        try await UserRoleModel.query(on: db).filter(\.$id == id).with(\.$permissions).first()
    }
}
