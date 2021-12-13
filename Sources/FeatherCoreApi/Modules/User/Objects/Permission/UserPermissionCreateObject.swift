//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension UserPermission {
    
    public struct Create: Codable {
        public var namespace: String
        public var context: String
        public var action: String
        public var name: String
        public var notes: String?

        public init(namespace: String,
                    context: String,
                    action: String,
                    name: String,
                    notes: String? = nil) {
            self.namespace = namespace
            self.context = context
            self.action = action
            self.name = name
            self.notes = notes
        }

    }

    
}
