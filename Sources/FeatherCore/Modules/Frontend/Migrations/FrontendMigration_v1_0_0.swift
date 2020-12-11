//
//  FrontendMigration_v1_0_0.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(FrontendMetadataModel.schema)
                .id()
                .field(FrontendMetadataModel.FieldKeys.module, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.model, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.reference, .uuid, .required)
                
                .field(FrontendMetadataModel.FieldKeys.title, .string)
                .field(FrontendMetadataModel.FieldKeys.excerpt, .data)
                .field(FrontendMetadataModel.FieldKeys.imageKey, .string)
                .field(FrontendMetadataModel.FieldKeys.date, .date, .required)
                
                .field(FrontendMetadataModel.FieldKeys.slug, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.status, .string, .required)
                .field(FrontendMetadataModel.FieldKeys.feedItem, .bool, .required)
                .field(FrontendMetadataModel.FieldKeys.canonicalUrl, .string)
                
                .field(FrontendMetadataModel.FieldKeys.filters, .array(of: .string), .required)
                .field(FrontendMetadataModel.FieldKeys.css, .data)
                .field(FrontendMetadataModel.FieldKeys.js, .data)

                .unique(on: FrontendMetadataModel.FieldKeys.slug)
                .unique(on: FrontendMetadataModel.FieldKeys.module, FrontendMetadataModel.FieldKeys.model, FrontendMetadataModel.FieldKeys.reference)
                .create(),
            db.schema(FrontendPageModel.schema)
                .id()
                .field(FrontendPageModel.FieldKeys.title, .string, .required)
                .field(FrontendPageModel.FieldKeys.content, .data)
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
                .field(FrontendMenuItemModel.FieldKeys.targetBlank, .bool, .required)
                .field(FrontendMenuItemModel.FieldKeys.menuId, .uuid, .required)
                .field(FrontendMenuItemModel.FieldKeys.permission, .string)
                .foreignKey(FrontendMenuItemModel.FieldKeys.menuId, references: FrontendMenuModel.schema, .id)
                .create(),
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(FrontendMenuItemModel.schema).delete(),
            db.schema(FrontendMenuModel.schema).delete(),
            db.schema(FrontendPageModel.schema).delete(),
            db.schema(FrontendMetadataModel.schema).delete(),
        ])
        
    }
}

