//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension UserPermission {
    
    public struct List: Codable {
        public var id: UUID
        public var name: String

        public init(id: UUID,
                    name: String) {
            self.id = id
            self.name = name
        }

    }

}
