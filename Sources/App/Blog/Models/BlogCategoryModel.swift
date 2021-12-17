//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

final class BlogCategoryModel: FeatherModel {
    typealias Module = BlogModule
    
    static var pathComponent: PathComponent = "categories"

    struct FieldKeys {
        struct v1 {
            static var title: FieldKey { "title" }
            static var imageKey: FieldKey { "image_key" }
            static var excerpt: FieldKey { "excerpt" }
            static var color: FieldKey { "color" }
            static var priority: FieldKey { "priority" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.title) var title: String
    @Field(key: FieldKeys.v1.imageKey) var imageKey: String?
    @Field(key: FieldKeys.v1.excerpt) var excerpt: String?
    @Field(key: FieldKeys.v1.color) var color: String?
    @Field(key: FieldKeys.v1.priority) var priority: Int
    @Siblings(through: BlogPostCategoryModel.self, from: \.$category, to: \.$post) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String? = nil,
         excerpt: String? = nil,
         color: String? = nil,
         priority: Int = 100)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.color = color
        self.priority = priority
    }
}

extension BlogCategoryModel: MetadataRepresentable {

    // NOTE: maybe we could reuse the same image key
    //  we should copy the file to the metadata folder with a new key
    var metadataCreate: WebMetadata.Create {
        .init(slug: Self.pathComponent.description + "/" + title.slugify(), title: title)
    }

//    var metadataPatch: WebMetadata.Patch {
//        .init(title: title, imageKey: imageKey)
//    }
}
