//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// module component
public protocol FeatherModule {
    
    /// name of the module
    static var moduleKey: String { get }
    /// path component based
    static var moduleKeyPathComponent: PathComponent { get }
    /// relative location of the module
    static var assetPath: String { get }

    static var name: String { get }
    
    /// module priority
    var priority: Int { get }
    /// bundle url

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws
    
    static var bundleUrl: URL? { get }
    
    static func permission(for action: Permission.Action, context: String?) -> Permission
    static func hookInstallPermission(for action: Permission.Action, context: String?) -> PermissionCreateObject
    
    static var adminLink: Link { get }
    
    static func sample(named name: String) -> String
}

///default module implementation
public extension FeatherModule {

    /// path component based on the module name
    static var moduleKeyPathComponent: PathComponent { .init(stringLiteral: moduleKey) }
    /// path of the module is based on the name by default
    static var assetPath: String { moduleKey + "/" }
    
    static var name: String { moduleKey.capitalized }
    
    /// default module priority 
    var priority: Int { 1000 }
    
    /// bundle url of the module
    static var bundleUrl: URL? { nil }

    var bundleUrl: URL? { Self.bundleUrl }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws {}


    static func permission(for action: Permission.Action, context: String? = nil) -> Permission {
        .init(namespace: moduleKey, context: context ?? "module", action: action)
    }

    static func hookInstallPermission(for action: Permission.Action, context: String? = nil) -> PermissionCreateObject {
        PermissionCreateObject(permission(for: action, context: context))
    }

    static var adminLink: Link { .init(label: name, url: ("admin" + "/" + moduleKey).safePath()) }

    static func sample(named name: String) -> String {
        do {
            guard let url = bundleUrl?.appendingPathComponent("Samples").appendingPathComponent(name) else {
                return ""
            }
            return try String(contentsOf: url, encoding: .utf8)
        }
        catch {
            return ""
        }
    }
}


internal extension FeatherModule {

    static var moduleBundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle").appendingPathComponent("Modules").appendingPathComponent(name.capitalized)
    }
}
