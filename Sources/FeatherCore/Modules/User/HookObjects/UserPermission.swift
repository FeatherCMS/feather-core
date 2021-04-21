//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 03..
//

import Foundation

public struct UserPermission: Codable {
    
    public let namespace: String
    public let context: String
    public let action: String
    public let name: String
    public let notes: String?
    
    public init(namespace: String, context: String, action: String, name: String, notes: String? = nil) {
        self.namespace = namespace
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }

    public init(_ permission: Permission, name: String? = nil, notes: String? = nil) {
        self.namespace = permission.namespace
        self.context = permission.context
        self.action = permission.action.identifier
        self.name = name ?? permission.name
        self.notes = notes
    }
}
