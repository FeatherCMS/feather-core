//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

final class BlogPostCategoryModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey: FeatherModelName = .init(singular: "post_category", plural: "post_categories")
    static var pathComponent: PathComponent = "categories"
    
    struct FieldKeys {
        struct v1 {
            static var postId: FieldKey { "post_id" }
            static var categoryId: FieldKey { "category_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.v1.categoryId) var category: BlogCategoryModel

    init() {}

    init(postId: UUID, categoryId: UUID) {
        self.$post.id = postId
        self.$category.id = categoryId
    }
}
