//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation

extension BlogAuthor {
    
    public struct List: Codable {
        public var id: UUID
        public var name: String
        public var imageKey: String?
        
        public init(id: UUID,
                    name: String,
                    imageKey: String? = nil) {
            self.id = id
            self.name = name
            self.imageKey = imageKey
        }
    }

}
