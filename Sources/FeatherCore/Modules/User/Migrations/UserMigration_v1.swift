//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

struct UserMigration_v1: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserAccountModel.schema)
                .id()
                .field(UserAccountModel.FieldKeys.email, .string, .required)
                .field(UserAccountModel.FieldKeys.password, .string, .required)
                .field(UserAccountModel.FieldKeys.root, .bool, .required)
                .unique(on: UserAccountModel.FieldKeys.email)
                .create(),
            db.schema(UserTokenModel.schema)
                .id()
                .field(UserTokenModel.FieldKeys.value, .string, .required)
                .field(UserTokenModel.FieldKeys.userId, .uuid, .required)
                .foreignKey(UserTokenModel.FieldKeys.userId, references: UserAccountModel.schema, .id)
                .unique(on: UserTokenModel.FieldKeys.value)
                .create(),
            db.schema(UserRoleModel.schema)
                .id()
                .field(UserRoleModel.FieldKeys.key, .string, .required)
                .field(UserRoleModel.FieldKeys.name, .string, .required)
                .field(UserRoleModel.FieldKeys.notes, .string)
                .unique(on: UserRoleModel.FieldKeys.key)
                .create(),
            db.schema(UserPermissionModel.schema)
                .id()
                .field(UserPermissionModel.FieldKeys.namespace, .string, .required)
                .field(UserPermissionModel.FieldKeys.context, .string, .required)
                .field(UserPermissionModel.FieldKeys.action, .string, .required)
                .field(UserPermissionModel.FieldKeys.name, .string, .required)
                .field(UserPermissionModel.FieldKeys.notes, .string)
                .unique(on: UserPermissionModel.FieldKeys.namespace,
                            UserPermissionModel.FieldKeys.context,
                            UserPermissionModel.FieldKeys.action)
                .create(),
            db.schema(UserAccountRoleModel.schema)
                .id()
                .field(UserAccountRoleModel.FieldKeys.userId, .uuid, .required)
                .field(UserAccountRoleModel.FieldKeys.roleId, .uuid, .required)
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
            db.schema(UserAccountRoleModel.schema).delete(),
            db.schema(UserPermissionModel.schema).delete(),
            db.schema(UserRoleModel.schema).delete(),
            db.schema(UserTokenModel.schema).delete(),
            db.schema(UserAccountModel.schema).delete(),
        ])
    }
}

