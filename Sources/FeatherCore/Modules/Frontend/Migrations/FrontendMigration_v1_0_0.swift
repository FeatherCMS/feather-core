//
//  FrontendMigration_v1_0_0.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(FrontendMetadata.schema)
                .id()
                .field(FrontendMetadata.FieldKeys.module, .string, .required)
                .field(FrontendMetadata.FieldKeys.model, .string, .required)
                .field(FrontendMetadata.FieldKeys.reference, .uuid, .required)
                
                .field(FrontendMetadata.FieldKeys.title, .string)
                .field(FrontendMetadata.FieldKeys.excerpt, .data)
                .field(FrontendMetadata.FieldKeys.imageKey, .string)
                .field(FrontendMetadata.FieldKeys.date, .date, .required)
                
                .field(FrontendMetadata.FieldKeys.slug, .string, .required)
                .field(FrontendMetadata.FieldKeys.status, .string, .required)
                .field(FrontendMetadata.FieldKeys.feedItem, .bool, .required)
                .field(FrontendMetadata.FieldKeys.canonicalUrl, .string)
                
                .field(FrontendMetadata.FieldKeys.filters, .array(of: .string), .required)
                .field(FrontendMetadata.FieldKeys.css, .data)
                .field(FrontendMetadata.FieldKeys.js, .data)

                .unique(on: FrontendMetadata.FieldKeys.slug)
                .unique(on: FrontendMetadata.FieldKeys.module, FrontendMetadata.FieldKeys.model, FrontendMetadata.FieldKeys.reference)
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
            db.schema(FrontendMetadata.schema).delete(),
        ])
        
    }
}

