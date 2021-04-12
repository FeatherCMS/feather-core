//
//  UserPermissionRouter.swift
//  UserPermission
//
//  Created by Tibor Bödecs on 2020. 12. 21..
//

import Foundation

public struct PermissionListObject: Codable {

    public var id: UUID
    public var name: String

    public init(id: UUID,
                name: String) {
        self.id = id
        self.name = name
    }

}
