//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import Foundation

public struct FeatherUser: Codable {
    
    public enum Level: String, Codable {
        case guest
        case authenticated
        case root
    }

    public var id: UUID
    public var level: Level
    public var roles: [FeatherRole]

    public init(id: UUID,
                level: Level,
                roles: [FeatherRole]) {
        self.id = id
        self.level = level
        self.roles = roles
    }

    public func hasPermission(_ permission: FeatherPermission) -> Bool {
        if level == .root {
            return true
        }
        for role in roles {
            for p in role.permissions {
                if p.key == permission.key {
                    return true
                }
            }
        }
        return false
    }
    
    public func hasPermission(_ key: String) -> Bool {
        hasPermission(.init(key))
    }
}
