//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

public extension HookObjects {

    struct AdminMenuItem: Codable {
        public let icon: String?
        public let link: Link
        public let priority: Int
        public let permission: String?
        
        public init(icon: String? = nil, link: Link, priority: Int = 0, permission: String? = nil) {
            self.icon = icon
            self.link = link
            self.priority = priority
            self.permission = permission
        }
    }
}

