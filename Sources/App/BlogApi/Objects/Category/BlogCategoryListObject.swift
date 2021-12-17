//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation
import FeatherCoreApi

extension BlogCategory {
  
    public struct List: Codable {
        public var id: UUID
        public var title: String?
        public var imageKey: String?
        public var color: String?
        public var priority: Int
        public var metadata: WebMetadata.Detail
        
        public init(id: UUID,
                    title: String?,
                    imageKey: String?,
                    color: String?,
                    priority: Int,
                    metadata: WebMetadata.Detail) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.color = color
            self.priority = priority
            self.metadata = metadata
        }

    }

}
