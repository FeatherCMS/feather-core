//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent

/// monitors model changes and calls the MetadataChangeDelegate if the metadata needs to be updated
public struct MetadataModelMiddleware<T: MetadataRepresentable>: ModelMiddleware {

    public init() {}

    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db).flatMap {
            var metadata = model.metadata
            metadata.id = UUID()
            metadata.module = T.Module.moduleKey
            metadata.model = T.modelKey
            metadata.reference = model.id
            metadata.filters = Feather.config.filters
            let model = WebMetadataModel()
            model.use(metadata)
            return model.create(on: db)
        }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db)
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db).flatMap {
            var metadata = model.metadata
            metadata.module = T.Module.moduleKey
            metadata.model = T.modelKey
            metadata.reference = model.id
            
            return WebMetadataModel.query(on: db)
                .filter(\.$module == metadata.module!)
                .filter(\.$model == metadata.model!)
                .filter(\.$reference == metadata.reference!)
                .delete()
        }
    }
}
