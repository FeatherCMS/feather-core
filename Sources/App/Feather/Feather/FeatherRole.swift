//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Foundation

public struct FeatherRole: Codable {

    public let id: UUID
    public let name: String
    public let permissions: [FeatherPermission]

    public init(id: UUID, name: String, permissions: [FeatherPermission]) {
        self.id = id
        self.name = name
        self.permissions = permissions
    }
}
