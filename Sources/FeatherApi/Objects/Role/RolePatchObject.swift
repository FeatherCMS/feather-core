//
//  UserRoleRouter.swift
//  UserRole
//
//  Created by Tibor Bödecs on 2020. 12. 21..
//

import Foundation

public struct RolePatchObject: Codable {

    public var key: String?
    public var name: String?
    public var notes: String?

    public init(key: String? = nil,
                name: String? = nil,
                notes: String? = nil) {
        self.key = key
        self.name = name
        self.notes = notes
    }
}
