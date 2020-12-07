//
//  UserMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

struct UserMigration_v1_0_0: Migration {
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserModel.schema)
                .id()
                .field(UserModel.FieldKeys.email, .string, .required)
                .field(UserModel.FieldKeys.password, .string, .required)
                .field(UserModel.FieldKeys.root, .bool, .required)
                .unique(on: UserModel.FieldKeys.email)
                .create(),
            db.schema(UserTokenModel.schema)
                .id()
                .field(UserTokenModel.FieldKeys.value, .string, .required)
                .field(UserTokenModel.FieldKeys.userId, .uuid, .required)
                .foreignKey(UserTokenModel.FieldKeys.userId, references: UserModel.schema, .id)
                .unique(on: UserTokenModel.FieldKeys.value)
                .create(),
            db.schema(UserRoleModel.schema)
                .id()
                .field(UserPermissionModel.FieldKeys.key, .string, .required)
                .field(UserPermissionModel.FieldKeys.name, .string, .required)
                .field(UserPermissionModel.FieldKeys.notes, .string)
                .unique(on: UserPermissionModel.FieldKeys.key)
                .create(),
            db.schema(UserPermissionModel.schema)
                .id()
                .field(UserPermissionModel.FieldKeys.key, .string, .required)
                .field(UserPermissionModel.FieldKeys.name, .string, .required)
                .field(UserPermissionModel.FieldKeys.notes, .string)
                .unique(on: UserPermissionModel.FieldKeys.key)
                .create(),
            db.schema(UserUserRoleModel.schema)
                .id()
                .field(UserUserRoleModel.FieldKeys.userId, .uuid, .required)
                .field(UserUserRoleModel.FieldKeys.roleId, .uuid, .required)
                .create(),
            db.schema(UserRolePermissionModel.schema)
                .id()
                .field(UserRolePermissionModel.FieldKeys.roleId, .uuid, .required)
                .field(UserRolePermissionModel.FieldKeys.permissionId, .uuid, .required)
                .create(),
        ])
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserRolePermissionModel.schema).delete(),
            db.schema(UserUserRoleModel.schema).delete(),
            db.schema(UserPermissionModel.schema).delete(),
            db.schema(UserRoleModel.schema).delete(),
            db.schema(UserTokenModel.schema).delete(),
            db.schema(UserModel.schema).delete(),
        ])
    }
}

