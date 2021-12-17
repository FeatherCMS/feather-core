//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation
import FeatherCoreApi

extension BlogCategory {

    public struct Detail: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int
        public var posts: [BlogPost.List]
        public var metadata: WebMetadata.Detail
        
        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    color: String?,
                    priority: Int,
                    posts: [BlogPost.List],
                    metadata: WebMetadata.Detail) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
            self.posts = posts
            self.metadata = metadata
        }
    }
}
