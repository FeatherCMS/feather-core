//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Foundation

public struct UserAccount {
    
    public var id: UUID
    public var email: String
    public var isRoot: Bool
    public var roles: [UserRole]

    public init(id: UUID,
                email: String,
                isRoot: Bool,
                roles: [UserRole]) {
        self.id = id
        self.email = email
        self.isRoot = isRoot
        self.roles = roles
    }

    public func hasPermission(_ permission: UserPermission) -> Bool {
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
        for role in roles {
            for p in role.permissions {
                if p.key == key {
                    return true
                }
            }
        }
        return false
    }
}

