//
//  UserRoleRouter.swift
//  UserRole
//
//  Created by Tibor Bödecs on 2020. 12. 21..
//

import Foundation

public struct RoleGetObject: Codable {

    public var id: UUID
    public var key: String
    public var name: String
    public var notes: String?

    public init(id: UUID,
                key: String,
                name: String,
                notes: String? = nil) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}
