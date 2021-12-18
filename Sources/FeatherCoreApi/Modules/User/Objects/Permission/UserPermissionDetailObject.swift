//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension UserPermission {

    public struct Detail: Codable {
        public var id: UUID
        public var namespace: String
        public var context: String
        public var action: String
        public var name: String
        public var notes: String?

        public init(id: UUID,
                    namespace: String,
                    context: String,
                    action: String,
                    name: String,
                    notes: String? = nil) {
            self.id = id
            self.namespace = namespace
            self.context = context
            self.action = action
            self.name = name
            self.notes = notes
        }    
    }
}
