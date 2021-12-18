//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public protocol FeatherModule {

    /// a unique key to identify the module
    static var moduleKey: String { get }
    static var pathComponent: PathComponent { get }
    static var permission: UserPermission { get }
    
    static func installPermissions() -> [UserPermission.Create]

    func boot(_ app: Application) throws
    func config(_ app: Application) throws
}

public extension FeatherModule {
    
    static var moduleKey: String {
        String(describing: self).dropLast(6).lowercased()
    }
    
    static var pathComponent: PathComponent {
        .init(stringLiteral: moduleKey)
    }

    static var permission: UserPermission {
        .init(namespace: moduleKey, context: "module", action: .detail)
    }
    
    static func installPermissions() -> [UserPermission.Create] {
        let permission = permission
        return [
            .init(namespace: permission.namespace,
                  context: permission.context,
                  action: permission.action.key,
                  name: permission.name)
        ]
    }
    
    func boot(_ app: Application) throws {}
    func config(_ app: Application) throws {}
}
