//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

public protocol FeatherDatabaseModel: Model where Self.IDValue == UUID {

    associatedtype Module: FeatherModule

    /// plural form of the database name
    static var featherIdentifier: String { get }

    var uuid: UUID { get }
    
    // TODO: check call site for id param values...
    static func isUnique(_ req: Request, _ filter: ModelValueFilter<Self>, _ id: UUID?) async throws -> Bool
}

public extension FeatherDatabaseModel {
    
    static var schema: String { Module.featherIdentifier + "_" + featherIdentifier }

    static var featherIdentifier: String {
        String(describing: self).dropFirst(Module.featherIdentifier.count).dropLast(5).lowercased() + "s"
    }

    var uuid: UUID { id! }
    
    static func isUnique(_ req: Request, _ filter: ModelValueFilter<Self>, _ id: UUID? = nil) async throws -> Bool {
        var query = query(on: req.db).filter(filter)
        if let id = id {
            query = query.filter(\Self._$id != id)
        }
        let count = try await query.count()
        return count == 0
    }
}
