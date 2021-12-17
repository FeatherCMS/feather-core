//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogAuthorLink {
    
    public struct Patch: Codable {
        public var label: String?
        public var url: String?
        public var priority: Int?
        public let authorId: UUID?
        
        public init(label: String? = nil,
                    url: String? = nil,
                    priority: Int? = nil,
                    authorId: UUID? = nil)
        {
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }

    }

}
