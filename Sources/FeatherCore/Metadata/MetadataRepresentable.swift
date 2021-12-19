//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCoreApi

public protocol MetadataRepresentable: FeatherModel {

    var webMetadata: WebMetadata { get }
}

public extension MetadataRepresentable {

    func filter(_ content: String, _ req: Request) async throws -> String {
        let allFilters: [FeatherFilter] = try await req.invokeAllFlatAsync("filters")
        let filters = allFilters.filter { metadataDetails.filters.contains($0.key) }.sorted { $0.priority > $1.priority }
        var result = content
        await filters.forEachAsync { filter in
            result = await filter.filter(result, req)
        }
        return result
    }
}

public extension MetadataRepresentable {

    /// return already joined metadata details object
    var metadataDetails: WebMetadata.Detail {
        WebMetadataApi().mapDetail(model: try! joined(WebMetadataModel.self))
    }

    /// query metadata relation and load the metadata details
    static func findMetadataDetails(for id: UUID, on db: Database) async throws -> WebMetadata.Detail? {
        guard let metadata = try await findMetadataBy(id: id, on: db) else {
            return nil
        }
        return WebMetadataApi().mapDetail(model: metadata)
    }

    static func queryJoinPublicMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinPublicMetadata()
    }
    
    static func queryJoinVisibleMetadata(on db: Database) -> QueryBuilder<Self> {
        query(on: db).joinVisibleMetadata()
    }
    
    static func queryJoinPublicMetadataFilterBy(path: String, on db: Database) -> QueryBuilder<Self> {
        queryJoinPublicMetadata(on: db).filterMetadataBy(path: path)
    }

    static func queryJoinVisibleMetadataFilterBy(path: String, on db: Database) -> QueryBuilder<Self> {
        queryJoinVisibleMetadata(on: db).filterMetadataBy(path: path)
    }
    

    func patchMetadata(id: UUID, req: Request, _ block: @escaping () -> WebMetadata.Patch) async throws {
        guard let metadata = try await Self.findMetadataBy(id: id, on: req.db) else {
            throw Abort(.notFound)
        }
        try await WebMetadataApi().mapPatch(req, model: metadata, input: block())
        try await metadata.update(on: req.db)
    }

    func publishMetadata(id: UUID, req: Request) async throws {
        try await patchMetadata(id: id, req: req) {
            .init(status: .published)
        }
    }

    func publishMetadataAsHome(id: UUID, req: Request) async throws {
        try await patchMetadata(id: id, req: req) {
            .init(slug: "", status: .published)
        }
    }
}


public extension AdminController where Model: MetadataRepresentable {
    
    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
//            Self.updateLink(id: model.uuid),
//            .init(label: "Preview", path: model.metadataDetails.slug.safePath(), isBlank: true),
//            WebMetadataController.updateLink("Metadata", id: model.metadataDetails.id),
        ]
    }

    func updateLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
//              Self.detailLink(id: model.uuid),
//              .init(label: "Preview", path: model.metadataDetails.slug.safePath(), isBlank: true),
//              WebMetadataController.updateLink("Metadata", id: model.metadataDetails.id),
        ]
    }
}

