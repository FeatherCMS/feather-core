//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// module component
public protocol FeatherModule {

    /// name of the module
    static var idKey: String { get }
    /// path component based
    static var idKeyPathComponent: PathComponent { get }
    /// relative location of the module
    static var assetPath: String { get }

    static var name: String { get }
    
    /// module priority
    var priority: Int { get }
    /// bundle url
    var bundleUrl: URL? { get }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws
    
    ///
    static func permission(for action: Permission.Action) -> Permission
    
    ///
    static func systemPermission(for action: Permission.Action) -> SystemPermission
}

///default module implementation
public extension FeatherModule {

    /// path component based on the module name
    static var idKeyPathComponent: PathComponent { .init(stringLiteral: idKey) }
    /// path of the module is based on the name by default
    static var assetPath: String { idKey + "/" }
    
    static var name: String { idKey.capitalized }
    
    /// default module priority 
    var priority: Int { 1000 }
    /// bundle url of the module
    var bundleUrl: URL? { nil }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws {}

    ///
    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: idKey, context: "module", action: action)
    }
    
    ///
    static func systemPermission(for action: Permission.Action) -> SystemPermission {
        SystemPermission(permission(for: action))
    }
}

