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
    static var modelPathComponent: PathComponent { get }
    
    /// unique identifier string for the model, based on the UUID
    var identifier: String { get }
    var uuid: UUID { get }
    
    

    static var idParamKey: String { get }
    static var idParamKeyPathComponent: PathComponent { get }
    static func getIdParameter(req: Request) -> UUID?

    static func permission(_ action: FeatherPermission.Action) -> FeatherPermission
    
    static func userPermissions() -> [UserPermission.Create]
}

public extension FeatherModel {
    
    static var schema: String { Module.moduleKey + "_" + modelKey }

    static var modelKey: String {
        let possibleName = String(describing: self).dropFirst(Module.moduleKey.count).dropLast(5).lowercased()
        if possibleName.hasSuffix("y") {
            return possibleName.dropLast() + "ies"
        }
        if possibleName.hasSuffix("s") {
            return possibleName
        }
        return possibleName + "s"
    }
    
    static var modelPathComponent: PathComponent {
        .init(stringLiteral: modelKey)
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

    static func userPermissions() -> [UserPermission.Create] {
        FeatherPermission.Action.crud.map { permission($0) }.map {
            UserPermission.Create(namespace: $0.namespace,
                                  context: $0.context,
                                  action: $0.action.description,
                                  name: $0.name)
        }
        
    }
    
    
}
