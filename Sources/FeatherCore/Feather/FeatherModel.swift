//
//  ViperModel.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// viper model
public protocol FeatherModel: Model where Self.IDValue == UUID {

    /// associated viper module
    associatedtype Module: FeatherModule

    /// pluar name of the model
    static var name: String { get }
    
    /// path of the model relative to the module (e.g. Module/Model/) can be used as a location or key
    static var path: String { get }
    
    /// path component
    static var pathComponent: PathComponent { get }
    
    static func allowedOrders() -> [FieldKey]
    static func defaultSort() -> FieldSort
    static func search(_ term: String) -> [ModelValueFilter<Self>]
    
    static func permission(for action: Permission.Action) -> Permission
    static func permissions() -> [Permission]
    static func systemPermissions() -> [SystemPermission]
}

public extension FeatherModel {

    /// schema is always prefixed with the module name
    static var schema: String { Module.name + "_" + Self.name }
    
    /// path of the model relative to the module (e.g. Module/Model/)
    static var path: String { Module.path + Self.name + "/" }
    
    /// path component based on the model name
    static var pathComponent: PathComponent { .init(stringLiteral: name) }
    
    static func allowedOrders() -> [FieldKey] { [] }
    static func defaultSort() -> FieldSort { .asc }
    static func search(_ term: String) -> [ModelValueFilter<Self>] { [] }

    

    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: Module.name, context: name, action: action)
    }

    static func permissions() -> [Permission] {
        Permission.Action.crud.map { permission(for: $0) }
    }
    
    static func systemPermissions() -> [SystemPermission] {
        permissions().map { SystemPermission($0) }
    }
}
