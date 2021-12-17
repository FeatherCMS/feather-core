//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogAuthorLink {
    
    public struct List: Codable {
        public var id: UUID
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID

        public init(id: UUID,
                    label: String,
                    url: String,
                    priority: Int,
                    authorId: UUID)
        {
            self.id = id
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }

    }

}
