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
            metadata.module = T.Module.moduleKey
            metadata.model = T.modelKey
            metadata.reference = model.id
            metadata.filters = Application.Config.filters
            let model = FrontendMetadataModel()
            model.use(metadata)
            
            /// avoid duplicate slug creation by appending a unique identifier
            return FrontendMetadataModel.query(on: db).filter(\.$slug == metadata.slug!).count().flatMap { count -> EventLoopFuture<Void> in
                if count > 0 {
                    model.slug = model.slug + "-" + UUID().uuidString
                }
                return model.create(on: db)
            }
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
            
            return FrontendMetadataModel.query(on: db)
                .filter(\.$module == metadata.module!)
                .filter(\.$model == metadata.model!)
                .filter(\.$reference == metadata.reference!)
                .delete()
        }
    }
}
