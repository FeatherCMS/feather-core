//
//  MetadataMigration_v1_0_0.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

struct MetadataMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(Metadata.schema)
            .id()
            .field(Metadata.FieldKeys.module, .string, .required)
            .field(Metadata.FieldKeys.model, .string, .required)
            .field(Metadata.FieldKeys.reference, .uuid, .required)
            
            .field(Metadata.FieldKeys.title, .string)
            .field(Metadata.FieldKeys.excerpt, .data)
            .field(Metadata.FieldKeys.imageKey, .string)
            .field(Metadata.FieldKeys.date, .date, .required)
            
            .field(Metadata.FieldKeys.slug, .string, .required)
            .field(Metadata.FieldKeys.status, .string, .required)
            .field(Metadata.FieldKeys.feedItem, .bool, .required)
            .field(Metadata.FieldKeys.canonicalUrl, .string)
            
            .field(Metadata.FieldKeys.filters, .array(of: .string), .required)
            .field(Metadata.FieldKeys.css, .data)
            .field(Metadata.FieldKeys.js, .data)

            .unique(on: Metadata.FieldKeys.slug)
            .unique(on: Metadata.FieldKeys.module, Metadata.FieldKeys.model, Metadata.FieldKeys.reference)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(Metadata.schema).delete()
    }
}

