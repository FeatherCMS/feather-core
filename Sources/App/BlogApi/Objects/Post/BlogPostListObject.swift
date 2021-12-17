//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Foundation
import FeatherCoreApi

extension BlogPost {
    public struct List: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var metadata: WebMetadata.Detail

        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    metadata: WebMetadata.Detail) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.metadata = metadata
        }

    }

}
