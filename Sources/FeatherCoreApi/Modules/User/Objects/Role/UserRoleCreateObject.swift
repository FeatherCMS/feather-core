//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension UserRole {
    
    public struct Create: Codable {
        public var key: String
        public var name: String
        public var notes: String?

        public init(key: String,
                    name: String,
                    notes: String? = nil) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
