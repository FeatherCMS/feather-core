//
//  MetadataMigration_v1_0_0.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

struct FrontendMetadataMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
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
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(FrontendMetadata.schema).delete()
    }
}

