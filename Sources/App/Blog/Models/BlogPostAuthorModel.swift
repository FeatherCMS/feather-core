//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

final class BlogPostAuthorModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey: String = "post_authors"
    
    struct FieldKeys {
        struct v1 {
            static var postId: FieldKey { "post_id" }
            static var authorId: FieldKey { "author_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.v1.authorId) var author: BlogAuthorModel
    
    init() {}

    init(postId: UUID, authorId: UUID) {
        self.$post.id = postId
        self.$author.id = authorId
    }
}
