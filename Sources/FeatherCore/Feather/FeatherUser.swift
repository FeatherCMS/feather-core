//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Foundation

public struct FeatherUser: Codable {
    
    public let id: UUID
    public let email: String
    public let isRoot: Bool
    public let permissions: [FeatherPermission]

    public init(id: UUID, email: String, isRoot: Bool, permissions: [FeatherPermission]) {
        self.id = id
        self.email = email
        self.isRoot = isRoot
        self.permissions = permissions
    }
}

