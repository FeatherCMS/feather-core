//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogAuthor {
    
    public struct Detail: Codable {
        public var id: UUID
        public var name: String
        public var imageKey: String?
        public var bio: String?
        public var links: [BlogAuthorLink.List]?

        public init(id: UUID,
                    name: String,
                    imageKey: String? = nil,
                    bio: String? = nil,
                    links: [BlogAuthorLink.List] = []) {
            self.id = id
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
            self.links = links
        }
    }

}
