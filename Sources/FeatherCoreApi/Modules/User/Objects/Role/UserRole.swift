//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Foundation

public struct UserRole: Codable {
    
    public var key: String
    public var permissions: [UserPermission]

    public init(key: String, permissions: [UserPermission]) {
        self.key = key
        self.permissions = permissions
    }
}
