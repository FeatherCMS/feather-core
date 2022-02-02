//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct WebMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(WebPageModel.schema)
                .id()
                .field(WebPageModel.FieldKeys.v1.title, .string, .required)
                .field(WebPageModel.FieldKeys.v1.content, .string)
                .create()
            
            try await db.schema(WebMetadataModel.schema)
                .id()
                .field(WebMetadataModel.FieldKeys.v1.module, .string, .required)
                .field(WebMetadataModel.FieldKeys.v1.model, .string, .required)
                .field(WebMetadataModel.FieldKeys.v1.reference, .uuid, .required)
                .field(WebMetadataModel.FieldKeys.v1.title, .string)
                .field(WebMetadataModel.FieldKeys.v1.excerpt, .string)
                .field(WebMetadataModel.FieldKeys.v1.imageKey, .string)
                .field(WebMetadataModel.FieldKeys.v1.date, .date, .required)
                .field(WebMetadataModel.FieldKeys.v1.slug, .string, .required)
                .field(WebMetadataModel.FieldKeys.v1.status, .string, .required)
                .field(WebMetadataModel.FieldKeys.v1.feedItem, .bool, .required)
                .field(WebMetadataModel.FieldKeys.v1.canonicalUrl, .string)
                .field(WebMetadataModel.FieldKeys.v1.filters, .array(of: .string), .required)
                .field(WebMetadataModel.FieldKeys.v1.css, .string)
                .field(WebMetadataModel.FieldKeys.v1.js, .string)
                .unique(on: WebMetadataModel.FieldKeys.v1.slug)
                .unique(on: WebMetadataModel.FieldKeys.v1.module,
                            WebMetadataModel.FieldKeys.v1.model,
                            WebMetadataModel.FieldKeys.v1.reference)
                .create()
            
            try await db.schema(WebMenuModel.schema)
                .id()
                .field(WebMenuModel.FieldKeys.v1.key, .string, .required)
                .field(WebMenuModel.FieldKeys.v1.name, .string, .required)
                .field(WebMenuModel.FieldKeys.v1.notes, .string)
                .unique(on: WebMenuModel.FieldKeys.v1.key)
                .create()
            
            try await db.schema(WebMenuItemModel.schema)
                .id()
                .field(WebMenuItemModel.FieldKeys.v1.label, .string, .required)
                .field(WebMenuItemModel.FieldKeys.v1.url, .string, .required)
                .field(WebMenuItemModel.FieldKeys.v1.priority, .int, .required)
                .field(WebMenuItemModel.FieldKeys.v1.isBlank, .bool, .required)
                .field(WebMenuItemModel.FieldKeys.v1.menuId, .uuid, .required)
                .field(WebMenuItemModel.FieldKeys.v1.permission, .string)
                .foreignKey(WebMenuItemModel.FieldKeys.v1.menuId, references: WebMenuModel.schema, .id)
                .create()
        }

        func revert(on db: Database) async throws {
            try await db.schema(WebMenuItemModel.schema).delete()
            try await db.schema(WebMenuModel.schema).delete()
            try await db.schema(WebMetadataModel.schema).delete()
            try await db.schema(WebPageModel.schema).delete()
        }
    }
}
