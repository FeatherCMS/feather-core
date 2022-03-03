//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol FeatherApiModule: FeatherApiComponent {
    
}

public extension FeatherApiModule {
    
    static func permission(for action: FeatherPermission.Action) -> FeatherPermission {
        .init(namespace: permissionKey, context: "module", action: action)
    }
    
    static func availablePermissions() -> [FeatherPermission] {
        [
            permission(for: .detail)
        ]
    }
}
