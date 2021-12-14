//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation

extension BlogCategory {
  
    public struct List: Codable {
        public var id: UUID
        public var title: String?
        public var imageKey: String?
        public var color: String?
        public var priority: Int
        
        public init(id: UUID,
                    title: String?,
                    imageKey: String?,
                    color: String?,
                    priority: Int) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.color = color
            self.priority = priority
        }

    }

}
