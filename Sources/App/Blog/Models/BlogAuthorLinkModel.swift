//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

final class BlogAuthorLinkModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey = "author_link"
    
    struct FieldKeys {
        struct v1 {
            static var label: FieldKey { "label" }
            static var url: FieldKey { "url" }
            static var priority: FieldKey { "priority" }
            static var authorId: FieldKey { "author_id" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.label) var label: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Field(key: FieldKeys.v1.priority) var priority: Int
    @Parent(key: FieldKeys.v1.authorId) var author: BlogAuthorModel
    
    init() { }
    
    init(id: UUID? = nil,
         label: String,
         url: String,
         priority: Int = 10,
         authorId: UUID)
    {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.$author.id = authorId
    }
}
