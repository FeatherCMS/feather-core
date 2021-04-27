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

    /// path identifier key
    static var modelKey: String { get }
    static var idParamKey: String { get }

    /// path component
    static var modelKeyPathComponent: PathComponent { get }
    static var idParamKeyPathComponent: PathComponent { get }
    static var createPathComponent: PathComponent { get }
    static var updatePathComponent: PathComponent { get }
    static var deletePathComponent: PathComponent { get }
    
    /// pluar name of the model
    static var name: FeatherModelName { get }
    /// path of the model relative to the module (e.g. Module/Model/) can be used as a location or key
    static var assetPath: String { get }
    
    static var isSearchable: Bool { get }
    static func allowedOrders() -> [FieldKey]
    static func defaultSort() -> FieldSort
    static func search(_ term: String) -> [ModelValueFilter<Self>]
    
    static func permission(for action: Permission.Action) -> Permission
    static func permissions() -> [Permission]
    static func hookInstallPermissions() -> [PermissionCreateObject]
    
    static func info(_ req: Request) -> ModelInfo
    
    static func getIdParameter(req: Request) -> UUID?
    
    static var adminLink: Link { get }

    static func adminLink(for id: UUID) -> Link
}

public extension FeatherModel {
    
    var identifier: String { id!.uuidString }
    static var idParamKey: String { modelKey + "Id" }
    static var idParamKeyPathComponent: PathComponent { .init(stringLiteral: ":" + idParamKey) }
    static var modelKeyPathComponent: PathComponent { .init(stringLiteral: modelKey) }
    static var createPathComponent: PathComponent { "create" }
    static var updatePathComponent: PathComponent { "update" }
    static var deletePathComponent: PathComponent { "delete" }
    
    static var schema: String { Module.moduleKey + "_" + modelKey }
    static var assetPath: String { Module.assetPath + modelKey + "/" }

    static var isSearchable: Bool { true }
    static func allowedOrders() -> [FieldKey] { [] }
    static func defaultSort() -> FieldSort { .asc }
    static func search(_ term: String) -> [ModelValueFilter<Self>] { [] }


    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: Module.moduleKey, context: modelKey, action: action)
    }

    static func permissions() -> [Permission] {
        Permission.Action.crud.map { permission(for: $0) }
    }
    
    static func hookInstallPermissions() -> [PermissionCreateObject] {
        permissions().map { .init($0) }
    }
        
    static func info(_ req: Request) -> ModelInfo {
        let list = req.checkPermission(for: permission(for: .list))
        let get = req.checkPermission(for: permission(for: .get))
        let create = req.checkPermission(for: permission(for: .create))
        let update = req.checkPermission(for: permission(for: .update))
        let patch = req.checkPermission(for: permission(for: .patch))
        let delete = req.checkPermission(for: permission(for: .delete))
    
        let permissions = ModelInfo.AvailablePermissions(list: list, get: get, create: create, update: update, patch: patch, delete: delete)
        return ModelInfo(idKey: modelKey,
                         idParamKey: idParamKey,
                         name: .init(singular: name.singular, plural: name.plural),
                         assetPath: assetPath,
                         module: .init(idKey: Module.moduleKey, name: Module.name, assetPath: Module.assetPath),
                         permissions: permissions,
                         isSearchable: isSearchable,
                         allowedOrders: allowedOrders().map(\.description),
                         defaultOrder: allowedOrders().first?.description,
                         defaultSort: defaultSort().rawValue)
    }

    /// check if a model is unique by a given filter (excludes the current object id if peresnt in a given request parameter)
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, req: Request) -> EventLoopFuture<Bool> {
        var query = query(on: req.db).filter(filter)
        if let modelId = getIdParameter(req: req) {
            query = query.filter(\Self._$id != modelId)
        }
        return query.count().map { $0 == 0  }
    }
    
    static func getIdParameter(req: Request) -> UUID? {
        guard let id = req.parameters.get(idParamKey), let uuid = UUID(uuidString: id) else {
            return nil
        }
        return uuid
    }

    static var adminLink: Link { .init(label: name.plural, url: ("admin" + "/" + Module.moduleKey + "/" + modelKey).safePath()) }

    static func adminLink(for id: UUID) -> Link {
        .init(label: name.singular, url: (adminLink.url + "/" + id.uuidString).safePath())
    }
}


