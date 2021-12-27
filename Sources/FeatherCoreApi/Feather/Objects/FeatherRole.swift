//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public struct FeatherRole: Codable {
    public var key: String
    public var permissions: [FeatherPermission]

    public init(key: String, permissions: [FeatherPermission]) {
        self.key = key
        self.permissions = permissions
    }
}
