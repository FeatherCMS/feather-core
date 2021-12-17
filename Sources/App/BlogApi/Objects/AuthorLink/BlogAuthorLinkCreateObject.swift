//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogAuthorLink {
    
    public struct Create: Codable {
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID
        
        public init(label: String,
                    url: String,
                    priority: Int = BlogAuthorLink.defaultPriority,
                    authorId: UUID)
        {
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }

    }

}
