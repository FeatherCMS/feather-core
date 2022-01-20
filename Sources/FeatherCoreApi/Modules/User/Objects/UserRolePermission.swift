//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 20..
//

public extension User {
    
    struct RolePermission: FeatherApiModel {
        public typealias Module = User
    }
}

public extension User.RolePermission {

    struct Create: Codable {
        public var key: String
        public var permissionKeys: [String]
        
        public init(key: String, permissionKeys: [String]) {
            self.key = key
            self.permissionKeys = permissionKeys
        }
    }
}
