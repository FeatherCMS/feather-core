//
//  UserPermissionRouter.swift
//  UserPermission
//
//  Created by Tibor Bödecs on 2020. 12. 21..
//

import Foundation

public struct PermissionPatchObject: Codable {

    public var namespace: String?
    public var context: String?
    public var action: String?
    public var name: String?
    public var notes: String?

    public init(namespace: String? = nil,
                context: String? = nil,
                action: String? = nil,
                name: String? = nil,
                notes: String? = nil) {
        self.namespace = namespace
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }

}
