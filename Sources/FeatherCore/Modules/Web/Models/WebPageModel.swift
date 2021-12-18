//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

final class WebPageModel: FeatherModel {
    typealias Module = WebModule

    struct FieldKeys {
        struct v1 {
            static var title: FieldKey { "title" }
            static var content: FieldKey { "content" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.title) var title: String
    @Field(key: FieldKeys.v1.content) var content: String

    init() { }

    init(id: UUID? = nil,
         title: String,
         content: String)
    {
        self.id = id
        self.title = title
        self.content = content
    }
}

extension WebPageModel: MetadataRepresentable {

    var webMetadata: WebMetadata {
        .init(slug: title.slugify(), title: title)
    }
}
