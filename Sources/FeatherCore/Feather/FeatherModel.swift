//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent
import AppKit

public protocol FeatherModel: Model where Self.IDValue == UUID {

    associatedtype Module: FeatherModule

    /// a unique key to identify the model
    ///
    /// it defaults to the plural name of the model itself without the module prefix
    /// for example UserAccountsModel -> accounts
    ///
    static var modelKey: FeatherModelName { get }
    static var pathComponent: PathComponent { get }
    static var idPathKey: String { get }
    static var idPathComponent: PathComponent { get }
    static var assetPath: String { get }

    /*
     
    modelKey
        post | posts
        menu_item | menu_items (asset path)
     
    Path compopnent
        posts
        items
     
    ID Paht key
        postId
    ID Path Component
        :postId
        :itemId
    */
    
    /// unique identifier string for the model, based on the UUID
    var identifier: String { get }
    var uuid: UUID { get }
    
    static func getIdParameter(req: Request) -> UUID?
    static func permission(_ action: UserPermission.Action) -> UserPermission
    static func installPermissions() -> [UserPermission.Create]
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, req: Request) async throws -> Bool
}

public extension FeatherModel {
    
    static var schema: String { Module.moduleKey + "_" + modelKey.plural }

    static var modelKey: FeatherModelName {
        .init(stringLiteral: String(describing: self).dropFirst(Module.moduleKey.count).dropLast(5).lowercased())
    }
    
    static var pathComponent: PathComponent {
        .init(stringLiteral: modelKey.plural )
    }

    static var idPathKey: String {
        modelKey.singular + "Id"
    }
    
    static var idPathComponent: PathComponent {
        .init(stringLiteral: ":" + idPathKey)
    }
    
    static var assetPath: String {
        [Module.moduleKey, modelKey.plural].joined(separator: "/")
    }

    var uuid: UUID { id! }
    var identifier: String { uuid.string }


    static func getIdParameter(req: Request) -> UUID? {
        guard let id = req.parameters.get(idPathKey), let uuid = UUID(uuidString: id) else {
            return nil
        }
        return uuid
    }

    static func permission(_ action: UserPermission.Action) -> UserPermission {
        UserPermission(namespace: Module.moduleKey, context: modelKey.singular, action: action)
    }

    static func installPermissions() -> [UserPermission.Create] {
        UserPermission.Action.crud.map { permission($0) }.map {
            UserPermission.Create(namespace: $0.namespace,
                                  context: $0.context,
                                  action: $0.action.key,
                                  name: $0.key)
        }
    }
    
    static func isUniqueBy(_ filter:  ModelValueFilter<Self>, req: Request) async throws -> Bool {
        var query = query(on: req.db).filter(filter)
        if let modelId = getIdParameter(req: req) {
            query = query.filter(\Self._$id != modelId)
        }
        let count = try await query.count()
        return count == 0
    }
}
