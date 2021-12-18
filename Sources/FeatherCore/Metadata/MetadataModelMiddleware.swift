//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent

public struct MetadataModelMiddleware<T: MetadataRepresentable>: AsyncModelMiddleware {

    public init() {}
    
    public func create(model: T, on db: Database, next: AnyAsyncModelResponder) async throws {
        try await next.create(model, on: db)
        let metadata = T.constructMetadataModel(for: model.uuid, using: model.webMetadata)
        return try await metadata.create(on: db)
    }
    
    public func update(model: T, on db: Database, next: AnyAsyncModelResponder) async throws {
        try await next.update(model, on: db)
//        maybe we could support proper patch updates?
//        guard let metadata = try await T.findMetadataBy(id: model.uuid, on: db) else {
//            throw Abort(.notFound)
//        }
//        WebMetadataApi().mapPatch(model: metadata, input: model.metadataPatch)
//        return try await metadata.update(on: db)
    }

    public func delete(model: T, force: Bool, on db: Database, next: AnyAsyncModelResponder) async throws {
        try await next.delete(model, force: force, on: db)
        return try await T.queryMetadataBy(id: model.uuid, on: db).delete()
    }
}
