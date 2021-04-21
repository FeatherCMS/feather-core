//
//  FrontendMigration_v1_0_0.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct SystemMigration_v1: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(SystemMetadataModel.schema)
                .id()
                .field(SystemMetadataModel.FieldKeys.module, .string, .required)
                .field(SystemMetadataModel.FieldKeys.model, .string, .required)
                .field(SystemMetadataModel.FieldKeys.reference, .uuid, .required)
                
                .field(SystemMetadataModel.FieldKeys.title, .string)
                .field(SystemMetadataModel.FieldKeys.excerpt, .string)
                .field(SystemMetadataModel.FieldKeys.imageKey, .string)
                .field(SystemMetadataModel.FieldKeys.date, .date, .required)
                
                .field(SystemMetadataModel.FieldKeys.slug, .string, .required)
                .field(SystemMetadataModel.FieldKeys.status, .string, .required)
                .field(SystemMetadataModel.FieldKeys.feedItem, .bool, .required)
                .field(SystemMetadataModel.FieldKeys.canonicalUrl, .string)
                
                .field(SystemMetadataModel.FieldKeys.filters, .array(of: .string), .required)
                .field(SystemMetadataModel.FieldKeys.css, .string)
                .field(SystemMetadataModel.FieldKeys.js, .string)

                .unique(on: SystemMetadataModel.FieldKeys.slug)
                .unique(on: SystemMetadataModel.FieldKeys.module, SystemMetadataModel.FieldKeys.model, SystemMetadataModel.FieldKeys.reference)
                .create(),
            db.schema(SystemPageModel.schema)
                .id()
                .field(SystemPageModel.FieldKeys.title, .string, .required)
                .field(SystemPageModel.FieldKeys.content, .string)
                .create(),
            db.schema(SystemMenuModel.schema)
                .id()
                .field(SystemMenuModel.FieldKeys.key, .string, .required)
                .field(SystemMenuModel.FieldKeys.name, .string, .required)
                .field(SystemMenuModel.FieldKeys.notes, .string)
                .unique(on: SystemMenuModel.FieldKeys.key)
                .create(),
            db.schema(SystemMenuItemModel.schema)
                .id()
                .field(SystemMenuItemModel.FieldKeys.icon, .string)
                .field(SystemMenuItemModel.FieldKeys.label, .string, .required)
                .field(SystemMenuItemModel.FieldKeys.url, .string, .required)
                .field(SystemMenuItemModel.FieldKeys.priority, .int, .required)
                .field(SystemMenuItemModel.FieldKeys.isBlank, .bool, .required)
                .field(SystemMenuItemModel.FieldKeys.menuId, .uuid, .required)
                .field(SystemMenuItemModel.FieldKeys.permission, .string)
                .field(SystemMenuItemModel.FieldKeys.notes, .string)
                .foreignKey(SystemMenuItemModel.FieldKeys.menuId, references: SystemMenuModel.schema, .id)
                .create(),
            db.schema(SystemVariableModel.schema)
                .id()
                .field(SystemVariableModel.FieldKeys.key, .string, .required)
                .field(SystemVariableModel.FieldKeys.name, .string, .required)
                .field(SystemVariableModel.FieldKeys.value, .string)
                .field(SystemVariableModel.FieldKeys.notes, .string)
                .unique(on: SystemVariableModel.FieldKeys.key)
                .create(),
            db.schema(SystemUserModel.schema)
                .id()
                .field(SystemUserModel.FieldKeys.email, .string, .required)
                .field(SystemUserModel.FieldKeys.password, .string, .required)
                .field(SystemUserModel.FieldKeys.root, .bool, .required)
                .unique(on: SystemUserModel.FieldKeys.email)
                .create(),
            db.schema(SystemTokenModel.schema)
                .id()
                .field(SystemTokenModel.FieldKeys.value, .string, .required)
                .field(SystemTokenModel.FieldKeys.userId, .uuid, .required)
                .foreignKey(SystemTokenModel.FieldKeys.userId, references: SystemUserModel.schema, .id)
                .unique(on: SystemTokenModel.FieldKeys.value)
                .create(),
            db.schema(SystemRoleModel.schema)
                .id()
                .field(SystemRoleModel.FieldKeys.key, .string, .required)
                .field(SystemRoleModel.FieldKeys.name, .string, .required)
                .field(SystemRoleModel.FieldKeys.notes, .string)
                .unique(on: SystemRoleModel.FieldKeys.key)
                .create(),
            db.schema(SystemPermissionModel.schema)
                .id()
                .field(SystemPermissionModel.FieldKeys.namespace, .string, .required)
                .field(SystemPermissionModel.FieldKeys.context, .string, .required)
                .field(SystemPermissionModel.FieldKeys.action, .string, .required)
                .field(SystemPermissionModel.FieldKeys.name, .string, .required)
                .field(SystemPermissionModel.FieldKeys.notes, .string)
                .unique(on: SystemPermissionModel.FieldKeys.namespace,
                            SystemPermissionModel.FieldKeys.context,
                            SystemPermissionModel.FieldKeys.action)
                .create(),
            db.schema(FeatherUserRoleModel.schema)
                .id()
                .field(FeatherUserRoleModel.FieldKeys.userId, .uuid, .required)
                .field(FeatherUserRoleModel.FieldKeys.roleId, .uuid, .required)
                .create(),
            db.schema(FeatherRolePermissionModel.schema)
                .id()
                .field(FeatherRolePermissionModel.FieldKeys.roleId, .uuid, .required)
                .field(FeatherRolePermissionModel.FieldKeys.permissionId, .uuid, .required)
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(SystemMenuItemModel.schema).delete(),
            db.schema(SystemMenuModel.schema).delete(),
            db.schema(SystemPageModel.schema).delete(),
            db.schema(SystemMetadataModel.schema).delete(),
            db.schema(SystemVariableModel.schema).delete(),
            db.schema(FeatherRolePermissionModel.schema).delete(),
            db.schema(FeatherUserRoleModel.schema).delete(),
            db.schema(SystemPermissionModel.schema).delete(),
            db.schema(SystemRoleModel.schema).delete(),
            db.schema(SystemTokenModel.schema).delete(),
            db.schema(SystemUserModel.schema).delete(),
        ])
        
    }
}

