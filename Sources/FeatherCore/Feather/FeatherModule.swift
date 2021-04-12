//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// module component
public protocol FeatherModule {

    /// name of the module
    static var name: String { get }
    var name: String { get }
    
    /// relative path of the module
    static var path: String { get }
    var path: String { get }
    
    /// path component based
    static var pathComponent: PathComponent { get }

    /// module priority
    var priority: Int { get }
    
    static var bundleUrl: URL? { get }
    var bundleUrl: URL? { get }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws
    
    static func permission(for action: Permission.Action) -> Permission
    
    static func systemPermission(for action: Permission.Action) -> SystemPermission
}

///default module implementation
public extension FeatherModule {

    // name of the module
    var name: String { Self.name }
    
    /// default module priority 
    var priority: Int { 1000 }

    /// path of the module is based on the name by default
    static var path: String { Self.name + "/" }
    var path: String { Self.path }
    
    /// path component based on the module name
    static var pathComponent: PathComponent { .init(stringLiteral: name) }

    /// bundle url of the module
    static var bundleUrl: URL? { nil }
    var bundleUrl: URL? { Self.bundleUrl }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws {}

    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: name, context: "module", action: action)
    }
    
    static func systemPermission(for action: Permission.Action) -> SystemPermission {
        SystemPermission(permission(for: action))
    }
}

