//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation

extension BlogCategory {

    public struct Patch: Codable {
        public var title: String?
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int?
        
        public init(title: String? = nil,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    color: String? = nil,
                    priority: Int? = nil)
        {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
        }

    }

}
