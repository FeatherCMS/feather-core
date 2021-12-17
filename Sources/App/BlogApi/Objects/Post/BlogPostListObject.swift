//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogPost {
    public struct List: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?

        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
        }

    }

}
