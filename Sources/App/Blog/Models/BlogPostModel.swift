//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

final class BlogPostModel: FeatherModel {
    typealias Module = BlogModule

    struct FieldKeys {
        struct v1 {
            static var title: FieldKey { "title" }
            static var imageKey: FieldKey { "image_key" }
            static var excerpt: FieldKey { "excerpt" }
            static var content: FieldKey { "content" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.title) var title: String
    @Field(key: FieldKeys.v1.imageKey) var imageKey: String?
    @Field(key: FieldKeys.v1.excerpt) var excerpt: String?
    @Field(key: FieldKeys.v1.content) var content: String?
    @Siblings(through: BlogPostCategoryModel.self, from: \.$post, to: \.$category) var categories: [BlogCategoryModel]
    @Siblings(through: BlogPostAuthorModel.self, from: \.$post, to: \.$author) var authors: [BlogAuthorModel]

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String? = nil,
         excerpt: String? = nil,
         content: String? = nil)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.content = content
    }
}

extension BlogPostModel {

    static func findWithCategoriesAndAuthorsBy(id: UUID, on db: Database) async throws -> BlogPostModel? {
        try await BlogPostModel.query(on: db)
            .joinMetadata()
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors)
            .first()
    }

}
extension BlogPostModel: MetadataRepresentable {

    var metadataCreate: WebMetadata.Create {
        .init(slug: Self.pathComponent.description + "/" + title.slugify(), title: title)
    }
}
