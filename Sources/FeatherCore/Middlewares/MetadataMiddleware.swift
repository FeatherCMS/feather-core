//
//  MetadataMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// a viper model extension that can return a metadata object
public protocol MetadataRepresentable: ViperModel where Self.IDValue == UUID {

    var metadata: Metadata { get }
}

/// monitors model changes and calls the MetadataChangeDelegate if the metadata needs to be updated
public struct MetadataModelMiddleware<T: MetadataRepresentable>: ModelMiddleware {

    public init() {}

    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db) .flatMap {
            Feather.metadataDelegate?.create(model.metadata, on: db) ?? db.eventLoop.future()
        }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db).flatMap {
            Feather.metadataDelegate?.update(model.metadata, on: db) ?? db.eventLoop.future()
        }
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db).flatMap {
            Feather.metadataDelegate?.delete(model.metadata, on: db) ?? db.eventLoop.future()
        }
    }
}
