//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public struct FeatherAccount: Codable {
    public var id: UUID
    public var email: String
    public var isRoot: Bool
    public var roles: [FeatherRole]

    public init(id: UUID,
                email: String,
                isRoot: Bool,
                roles: [FeatherRole]) {
        self.id = id
        self.email = email
        self.isRoot = isRoot
        self.roles = roles
    }

    public func hasPermission(_ permission: FeatherPermission) -> Bool {
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
