//
//  UserRoleRouter.swift
//  UserRole
//
//  Created by Tibor Bödecs on 2020. 12. 21..
//

import Foundation

public struct RoleUpdateObject: Codable {

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
