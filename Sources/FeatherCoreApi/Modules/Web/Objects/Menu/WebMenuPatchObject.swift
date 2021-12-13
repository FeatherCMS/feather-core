//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

extension WebMenu {
 
    public struct Patch: Codable {
        public let key: String?
        public let name: String?
        public let icon: String?
        public let notes: String?
        public let permission: String?
        
        public init(key: String? = nil,
                    name: String? = nil,
                    icon: String? = nil,
                    notes: String? = nil,
                    permission: String? = nil)
        {
            self.key = key
            self.name = name
            self.icon = icon
            self.notes = notes
            self.permission = permission
        }
    }



}
