//
//  MetadataMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public protocol MetadataRepresentable: ViperModel where Self.IDValue == UUID {

    var metadata: Metadata { get }
}

/// monitors model changes and calls the MetadataChangeDelegate if the metadata needs to be updated
public struct MetadataModelMiddleware<T: MetadataRepresentable>: ModelMiddleware {
    
    public init() {}
    
    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db)
            .flatMap {
                let content = FrontendMetadataModel(id: UUID(),
                                               module: Model.Module.name,
                                               model: Model.name,
                                               reference: model.id!,
                                               slug: model.metadata.slug)
                content.use(model.metadata, updateSlug: true)
                return content.create(on: db)
            }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db)
            .flatMap {
                FrontendMetadataModel.query(on: db)
                    .filter(\.$reference == model.id!)
                    .filter(\.$module == Model.Module.name)
                    .filter(\.$model == Model.name)
                    .first()
            }
            .flatMap { content -> EventLoopFuture<Void> in
                guard let content = content else {
                    return db.eventLoop.future()
                }
                content.use(model.metadata, updateSlug: false)
                return content.update(on: db)
            }
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db)
            .flatMap {
                FrontendMetadataModel.query(on: db)
                    .filter(\.$reference == model.id!)
                    .filter(\.$module == Model.Module.name)
                    .filter(\.$model == Model.name)
                    .delete()
            }
    }
}
