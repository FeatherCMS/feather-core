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
    
    private let app: Application

    /// init with an app reference
    public init(app: Application) {
        self.app = app
    }

    /// on create action we call the willUpdate method using the delegate
    public func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db)
            .flatMap {
                let future: EventLoopFuture<Void>? = app.invoke("metadata-create", args: [
                    "metadata": model.metadata,
                    "reference": model.id!,
                    "module": Model.Module.name,
                    "model": Model.name,
                ])
                return future ?? db.eventLoop.future()
            }
    }
    
    /// on update action we call the willUpdate method using the delegate
    public func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db)
            .flatMap {
                let future: EventLoopFuture<Void>? = app.invoke("metadata-update", args: [
                    "metadata": model.metadata,
                    "reference": model.id!,
                    "module": Model.Module.name,
                    "model": Model.name,
                ])
                return future ?? db.eventLoop.future()
            }
    }
    
    /// on delete action, we remove the associated metadata
    public func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db).flatMap {
            let future: EventLoopFuture<Void>? = app.invoke("metadata-delete", args: [
                "reference": model.id!,
                "module": Model.Module.name,
                "model": Model.name,
            ])
            return future ?? db.eventLoop.future()
        }
    }
}
