//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol FeatherApiModel: FeatherApiComponent {    
    associatedtype Module: FeatherApiModule
    
    static var pathIdKey: String { get }
}

public extension FeatherApiModel {
    
    static var pathIdKey: String { String(describing: self).lowercased() + "Id" }
    static var pathKey: String { String(describing: self).lowercased() + "s" }
    
    static func permission(for action: FeatherPermission.Action) -> FeatherPermission {
        .init(namespace: Module.permissionKey, context: permissionKey, action: action)
    }
}
