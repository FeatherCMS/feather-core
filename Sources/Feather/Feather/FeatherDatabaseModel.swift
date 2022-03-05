//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Fluent

public protocol FeatherDatabaseModel: Model where Self.IDValue == UUID {
    associatedtype Module: FeatherModule

    /// unique key for the database model
    static var uniqueKey: String { get }

    /// unique identifier of the database model
    var uuid: UUID { get }
}

public extension FeatherDatabaseModel {
    
    static var schema: String { Module.uniqueKey + "_" + uniqueKey }

    static var uniqueKey: String {
        String(describing: self).dropFirst(Module.uniqueKey.count).dropLast(5).lowercased() + "s"
    }

    var uuid: UUID { id! }
}
