//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

struct UserMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(UserAccountModel.schema)
                .id()
                .field(UserAccountModel.FieldKeys.v1.email, .string, .required)
                .field(UserAccountModel.FieldKeys.v1.password, .string, .required)
                .field(UserAccountModel.FieldKeys.v1.isRoot, .bool, .required)
                .unique(on: UserAccountModel.FieldKeys.v1.email)
                .create()
            
            try await db.schema(UserTokenModel.schema)
                .id()
                .field(UserTokenModel.FieldKeys.v1.value, .string, .required)
                .field(UserTokenModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(UserTokenModel.FieldKeys.v1.userId, references: UserAccountModel.schema, .id)
                .unique(on: UserTokenModel.FieldKeys.v1.value)
                .create()
            
            try await db.schema(UserRoleModel.schema)
                .id()
                .field(UserRoleModel.FieldKeys.v1.key, .string, .required)
                .field(UserRoleModel.FieldKeys.v1.name, .string, .required)
                .field(UserRoleModel.FieldKeys.v1.notes, .string)
                .unique(on: UserRoleModel.FieldKeys.v1.key)
                .create()
            
            try await db.schema(UserPermissionModel.schema)
                .id()
                .field(UserPermissionModel.FieldKeys.v1.namespace, .string, .required)
                .field(UserPermissionModel.FieldKeys.v1.context, .string, .required)
                .field(UserPermissionModel.FieldKeys.v1.action, .string, .required)
                .field(UserPermissionModel.FieldKeys.v1.name, .string, .required)
                .field(UserPermissionModel.FieldKeys.v1.notes, .string)
                .unique(on: UserPermissionModel.FieldKeys.v1.namespace,
                            UserPermissionModel.FieldKeys.v1.context,
                            UserPermissionModel.FieldKeys.v1.action)
                .create()
            
            try await db.schema(UserAccountRoleModel.schema)
                .id()
                .field(UserAccountRoleModel.FieldKeys.v1.userId, .uuid, .required)
                .field(UserAccountRoleModel.FieldKeys.v1.roleId, .uuid, .required)
                .create()
            
            try await db.schema(UserRolePermissionModel.schema)
                .id()
                .field(UserRolePermissionModel.FieldKeys.v1.roleId, .uuid, .required)
                .field(UserRolePermissionModel.FieldKeys.v1.permissionId, .uuid, .required)
                .create()
        }
        
        func revert(on db: Database) async throws {
            try await db.schema(UserRolePermissionModel.schema).delete()
            try await db.schema(UserAccountRoleModel.schema).delete()
            try await db.schema(UserPermissionModel.schema).delete()
            try await db.schema(UserRoleModel.schema).delete()
            try await db.schema(UserTokenModel.schema).delete()
            try await db.schema(UserAccountModel.schema).delete()
        }
    }
}
