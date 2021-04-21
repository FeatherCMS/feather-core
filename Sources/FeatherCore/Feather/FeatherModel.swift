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
    static var name: FeatherModelName { get }
    
    /// path of the model relative to the module (e.g. Module/Model/) can be used as a location or key
    static var path: String { get }
    
    /// path component
    static var pathComponent: PathComponent { get }
    
    static var createPathComponent: PathComponent { get }
    static var updatePathComponent: PathComponent { get }
    static var deletePathComponent: PathComponent { get }
    
    static func allowedOrders() -> [FieldKey]
    static func defaultSort() -> FieldSort
    static func search(_ term: String) -> [ModelValueFilter<Self>]
    
    static func permission(for action: Permission.Action) -> Permission
    static func permissions() -> [Permission]
    static func systemPermissions() -> [SystemPermission]
}

public extension FeatherModel {
    
    var identifier: String { id!.uuidString }

    /// schema is always prefixed with the module name
    static var schema: String { Module.name + "_" + Self.name.plural }
    
    /// path of the model relative to the module (e.g. Module/Model/)
    static var path: String { Module.path + Self.name.plural + "/" }
    
    /// path component based on the model name
    static var pathComponent: PathComponent { .init(stringLiteral: name.plural) }
    
    static var createPathComponent: PathComponent { "create" }
    static var updatePathComponent: PathComponent { "update" }
    static var deletePathComponent: PathComponent { "delete" }
    
    static func allowedOrders() -> [FieldKey] { [] }
    static func defaultSort() -> FieldSort { .asc }
    static func search(_ term: String) -> [ModelValueFilter<Self>] { [] }

    

    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: Module.name, context: name.plural, action: action)
    }

    static func permissions() -> [Permission] {
        Permission.Action.crud.map { permission(for: $0) }
    }
    
    static func systemPermissions() -> [SystemPermission] {
        permissions().map { SystemPermission($0) }
    }
    
    static func info(_ req: Request) -> ModelInfo {
        let list = req.checkPermission(for: permission(for: .list))
        let get = req.checkPermission(for: permission(for: .get))
        let create = req.checkPermission(for: permission(for: .create))
        let update = req.checkPermission(for: permission(for: .update))
        let patch = req.checkPermission(for: permission(for: .patch))
        let delete = req.checkPermission(for: permission(for: .delete))
    
        let permissions = ModelInfo.AvailablePermissions(list: list, get: get, create: create, update: update, patch: patch, delete: delete)
        return ModelInfo(key: Self.name.plural,
                         title: Self.name.singular,
                         module: .init(key: Module.name,
                                       title: Module.name,
                                       path: "/admin/" + Module.path),
                         permissions: permissions, urls: .init(list: "/admin/" + path))
    }

    /// check if a model is unique by a given filter (excludes the current object id if peresnt in a given request parameter)
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, paramKey: String = "id", req: Request) -> EventLoopFuture<Bool> {
        var query = Self.query(on: req.db).filter(filter)
        if let id = req.parameters.get(paramKey), let uuid = UUID(uuidString: id) {
            query = query.filter(\Self._$id != uuid)
        }
        return query.count().map { $0 == 0  }
    }

}


