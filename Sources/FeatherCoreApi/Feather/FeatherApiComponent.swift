//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol FeatherApiComponent {
    
    static var pathKey: String { get }
    static var permissionKey: String { get }
//    static var assetKey: String { get }
    
    static func permission(for action: FeatherPermission.Action) -> FeatherPermission
    static func availablePermissions() -> [FeatherPermission]
}

public extension FeatherApiComponent {

    static var pathKey: String { String(describing: self).lowercased() }
    static var permissionKey: String { String(describing: self).lowercased() }
//    static var assetKey: String { String(describing: self).lowercased() }
    
    static func availablePermissions() -> [FeatherPermission] {
        FeatherPermission.Action.crud.map { permission(for: $0) }
    }
}
