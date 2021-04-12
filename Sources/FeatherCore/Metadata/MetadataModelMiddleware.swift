//
//  MetadataModelMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

/// monitors model changes and calls the MetadataChangeDelegate if the metadata needs to be updated
public struct MetadataModelMiddleware<T: MetadataRepresentable>: ModelMiddleware {

    public init() {}

    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db).flatMap {
            var metadata = model.metadata
            metadata.id = UUID()
            metadata.module = T.Module.name
            metadata.model = T.name
            metadata.reference = model.id
            let model = SystemMetadataModel()
            model.use(metadata)
            return model.create(on: db)
        }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        // NOTE: we don't want to update metadata info on model update
        next.update(model, on: db)//.flatMap {
//            var metadata = model.metadata
//            metadata.module = T.Module.name
//            metadata.model = T.name
//            metadata.reference = model.id
//            metadata.slug = nil
//            return Feather.metadataDelegate?.update(metadata, on: db) ?? db.eventLoop.future()
//        }
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db).flatMap {
            var metadata = model.metadata
            metadata.module = T.Module.name
            metadata.model = T.name
            metadata.reference = model.id
            
            return SystemMetadataModel.query(on: db)
                .filter(\.$module == metadata.module!)
                .filter(\.$model == metadata.model!)
                .filter(\.$reference == metadata.reference!)
                .delete()
        }
    }
}
