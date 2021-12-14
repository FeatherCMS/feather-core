//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Fluent

struct BlogMigrations {

    struct v1: AsyncMigration {

        func prepare(on db: Database) async throws {
            try await db.schema(BlogCategoryModel.schema)
                .id()
                .field(BlogCategoryModel.FieldKeys.v1.title, .string, .required)
                .field(BlogCategoryModel.FieldKeys.v1.imageKey, .string)
                .field(BlogCategoryModel.FieldKeys.v1.excerpt, .string)
                .field(BlogCategoryModel.FieldKeys.v1.color, .string)
                .field(BlogCategoryModel.FieldKeys.v1.priority, .int, .required)
                .unique(on: BlogCategoryModel.FieldKeys.v1.title)
                .create()
            
            try await db.schema(BlogAuthorModel.schema)
                .id()
                .field(BlogAuthorModel.FieldKeys.v1.name, .string, .required)
                .field(BlogAuthorModel.FieldKeys.v1.imageKey, .string)
                .field(BlogAuthorModel.FieldKeys.v1.bio, .string)
                .create()
            
            try await db.schema(BlogAuthorLinkModel.schema)
                .id()
                .field(BlogAuthorLinkModel.FieldKeys.v1.label, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.v1.url, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.v1.priority, .int, .required)
                .field(BlogAuthorLinkModel.FieldKeys.v1.authorId, .uuid, .required)
                .foreignKey(BlogAuthorLinkModel.FieldKeys.v1.authorId, references: BlogAuthorModel.schema, .id)
                .create()
            
            try await db.schema(BlogPostModel.schema)
                .id()
                .field(BlogPostModel.FieldKeys.v1.title, .string, .required)
                .field(BlogPostModel.FieldKeys.v1.imageKey, .string)
                .field(BlogPostModel.FieldKeys.v1.excerpt, .string)
                .field(BlogPostModel.FieldKeys.v1.content, .string)
                .create()
            
            try await db.schema(BlogPostCategoryModel.schema)
                .id()
                .field(BlogPostCategoryModel.FieldKeys.v1.postId, .uuid, .required)
                .field(BlogPostCategoryModel.FieldKeys.v1.categoryId, .uuid, .required)
                .create()

            try await db.schema(BlogPostAuthorModel.schema)
                .id()
                .field(BlogPostAuthorModel.FieldKeys.v1.postId, .uuid, .required)
                .field(BlogPostAuthorModel.FieldKeys.v1.authorId, .uuid, .required)
                .create()
        }
        
        func revert(on db: Database) async throws {
            try await db.schema(BlogAuthorLinkModel.schema).delete()
            try await db.schema(BlogAuthorModel.schema).delete()
            try await db.schema(BlogCategoryModel.schema).delete()
            try await db.schema(BlogPostAuthorModel.schema).delete()
            try await db.schema(BlogPostCategoryModel.schema).delete()
            try await db.schema(BlogPostModel.schema).delete()
        }
    }
}
