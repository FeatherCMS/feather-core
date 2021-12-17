//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

public protocol FeatherModel: Model where Self.IDValue == UUID {

    associatedtype Module: FeatherModule

    /// a unique key to identify the model
    ///
    /// it defaults to the plural name of the model itself without the module prefix
    /// for example UserAccountsModel -> accounts
    ///
    static var modelKey: String { get }
    static var pathComponent: PathComponent { get }
    static var assetPath: String { get }
    
    /// unique identifier string for the model, based on the UUID
    var identifier: String { get }
    var uuid: UUID { get }

    static var idParamKey: String { get }
    static var idParamKeyPathComponent: PathComponent { get }
    static func getIdParameter(req: Request) -> UUID?

    static func permission(_ action: FeatherPermission.Action) -> FeatherPermission
    
    static func installPermissions() -> [UserPermission.Create]
    
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, req: Request) async -> Bool
}

public extension FeatherModel {
    
    static var schema: String { Module.moduleKey + "_" + pathComponent.description }

    static var modelKey: String {
        String(describing: self).dropFirst(Module.moduleKey.count).dropLast(5).lowercased()
    }
    
    static var pathComponent: PathComponent {
        .init(stringLiteral: modelKey + "s")
    }

    static var assetPath: String {
        [Module.pathComponent, pathComponent].path
    }

    var uuid: UUID { id! }
    var identifier: String { uuid.uuidString }
    
    static var idParamKey: String { modelKey + "Id" }

    static var idParamKeyPathComponent: PathComponent { .init(stringLiteral: ":" + idParamKey) }

    static func getIdParameter(req: Request) -> UUID? {
        guard let id = req.parameters.get(idParamKey), let uuid = UUID(uuidString: id) else {
            return nil
        }
        return uuid
    }

    static func permission(_ action: FeatherPermission.Action) -> FeatherPermission {
        FeatherPermission(namespace: Module.moduleKey, context: modelKey, action: action)
    }

    static func installPermissions() -> [UserPermission.Create] {
        FeatherPermission.Action.crud.map { permission($0) }.map {
            UserPermission.Create(namespace: $0.namespace,
                                  context: $0.context,
                                  action: $0.action.description,
                                  name: $0.name)
        }
    }
    
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, req: Request) async -> Bool {
        var query = query(on: req.db).filter(filter)
        if let modelId = getIdParameter(req: req) {
            query = query.filter(\Self._$id != modelId)
        }
        // TODO: proper error handler...
        let count = try? await query.count()
        return count == 0
    }
}
