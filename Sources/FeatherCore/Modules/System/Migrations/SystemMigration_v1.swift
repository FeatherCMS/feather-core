//
//  FrontendMigration_v1_0_0.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct SystemMigration_v1: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(FrontendMetadataModel.schema)
                .id()
                .field(FrontendMetadataModel.FieldKeys.module, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.model, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.reference, .uuid, .required)
                
                .field(FrontendMetadataModel.FieldKeys.title, .string)
                .field(FrontendMetadataModel.FieldKeys.excerpt, .string)
                .field(FrontendMetadataModel.FieldKeys.imageKey, .string)
                .field(FrontendMetadataModel.FieldKeys.date, .date, .required)
                
                .field(FrontendMetadataModel.FieldKeys.slug, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.status, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.feedItem, .bool, .required)
                .field(FrontendMetadataModel.FieldKeys.canonicalUrl, .string)
                
                .field(FrontendMetadataModel.FieldKeys.filters, .array(of: .string), .required)
                .field(FrontendMetadataModel.FieldKeys.css, .string)
                .field(FrontendMetadataModel.FieldKeys.js, .string)

                .unique(on: FrontendMetadataModel.FieldKeys.slug)
                .unique(on: FrontendMetadataModel.FieldKeys.module, FrontendMetadataModel.FieldKeys.model, FrontendMetadataModel.FieldKeys.reference)
                .create(),
            db.schema(FrontendPageModel.schema)
                .id()
                .field(FrontendPageModel.FieldKeys.title, .string, .required)
                .field(FrontendPageModel.FieldKeys.content, .string)
                .create(),
            db.schema(FrontendMenuModel.schema)
                .id()
                .field(FrontendMenuModel.FieldKeys.key, .string, .required)
                .field(FrontendMenuModel.FieldKeys.name, .string, .required)
                .field(FrontendMenuModel.FieldKeys.notes, .string)
                .unique(on: FrontendMenuModel.FieldKeys.key)
                .create(),
            db.schema(FrontendMenuItemModel.schema)
                .id()
                .field(FrontendMenuItemModel.FieldKeys.icon, .string)
                .field(FrontendMenuItemModel.FieldKeys.label, .string, .required)
                .field(FrontendMenuItemModel.FieldKeys.url, .string, .required)
                .field(FrontendMenuItemModel.FieldKeys.priority, .int, .required)
                .field(FrontendMenuItemModel.FieldKeys.isBlank, .bool, .required)
                .field(FrontendMenuItemModel.FieldKeys.menuId, .uuid, .required)
                .field(FrontendMenuItemModel.FieldKeys.permission, .string)
                .field(FrontendMenuItemModel.FieldKeys.notes, .string)
                .foreignKey(FrontendMenuItemModel.FieldKeys.menuId, references: FrontendMenuModel.schema, .id)
                .create(),
            db.schema(SystemVariableModel.schema)
                .id()
                .field(SystemVariableModel.FieldKeys.key, .string, .required)
                .field(SystemVariableModel.FieldKeys.name, .string, .required)
                .field(SystemVariableModel.FieldKeys.value, .string)
                .field(SystemVariableModel.FieldKeys.notes, .string)
                .unique(on: SystemVariableModel.FieldKeys.key)
                .create(),
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
            db.schema(FrontendMenuItemModel.schema).delete(),
            db.schema(FrontendMenuModel.schema).delete(),
            db.schema(FrontendPageModel.schema).delete(),
            db.schema(FrontendMetadataModel.schema).delete(),
            db.schema(SystemVariableModel.schema).delete(),
            db.schema(UserRolePermissionModel.schema).delete(),
            db.schema(UserAccountRoleModel.schema).delete(),
            db.schema(UserPermissionModel.schema).delete(),
            db.schema(UserRoleModel.schema).delete(),
            db.schema(UserTokenModel.schema).delete(),
            db.schema(UserAccountModel.schema).delete(),
        ])
        
    }
}

