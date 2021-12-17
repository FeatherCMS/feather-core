//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogPost {

    public struct Detail: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        public var categories: [BlogCategory.List]
        public var authors: [BlogAuthor.List]
        
        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    content: String?,
                    categories: [BlogCategory.List] = [],
                    authors: [BlogAuthor.List] = []) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
            self.categories = categories
            self.authors = authors
        }

    }

}
