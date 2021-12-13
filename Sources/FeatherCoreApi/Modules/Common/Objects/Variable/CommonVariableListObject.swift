//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

extension CommonVariable {
    
    public struct List: Codable {
        public var id: UUID
        public var key: String
        public var value: String?

        public init(id: UUID,
                    key: String,
                    value: String? = nil)
        {
            self.id = id
            self.key = key
            self.value = value
        }
    }
}
