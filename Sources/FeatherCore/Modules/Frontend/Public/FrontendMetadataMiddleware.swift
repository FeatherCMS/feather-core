//
//  MetadataMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

public protocol FrontendMetadataChangeDelegate: ViperModel where Self.IDValue == UUID {
    /// you can provide convenience a getter for using slug values
    var slug: String { get }
    
    /// if a model data has been changed this method will be called so you can alter the metadata to reflect the new changes
    func willUpdate(_: FrontendMetadata)
}

/// monitors model changes and calls the MetadataChangeDelegate if the metadata needs to be updated
public struct FrontendMetadataMiddleware<T: FrontendMetadataChangeDelegate>: ModelMiddleware {
    
    public init() {}
    
    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db)
            .flatMap {
                let content = FrontendMetadata(id: UUID(),
                                               module: Model.Module.name,
                                               model: Model.name,
                                               reference: model.id!,
                                               slug: model.slug)
                model.willUpdate(content)
                return content.create(on: db)
            }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db)
            .flatMap {
                FrontendMetadata.query(on: db)
                    .filter(\.$reference == model.id!)
                    .filter(\.$module == Model.Module.name)
                    .filter(\.$model == Model.name)
                    .first()
            }
            .flatMap { content -> EventLoopFuture<Void> in
                guard let content = content else {
                    return db.eventLoop.future()
                }
                model.willUpdate(content)
                return content.update(on: db)
            }
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db)
            .flatMap {
                FrontendMetadata.query(on: db)
                    .filter(\.$reference == model.id!)
                    .filter(\.$module == Model.Module.name)
                    .filter(\.$model == Model.name)
                    .delete()
            }
    }
}
