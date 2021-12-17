//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogPost {

    public struct Update: Codable {
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        
        public init(title: String,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    content: String? = nil)
        {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
        }

    }

}
