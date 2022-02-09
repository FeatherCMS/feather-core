//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

public protocol MetadataRepresentable: FeatherDatabaseModel {

    var webMetadata: FeatherMetadata { get }
}

public extension MetadataRepresentable {

    func filter(_ content: String, _ req: Request) async throws -> String {
        let allFilters: [FeatherFilter] = req.invokeAllFlat(.filters)
        let filters = allFilters.filter { f in
            featherMetadata.filters.isEmpty || featherMetadata.filters.contains(f.key)
        }.sorted { $0.priority > $1.priority }
        var result = content
        try await filters.forEachAsync { filter in
            result = try await filter.filter(result, req)
        }
        return result
    }
}

public extension MetadataRepresentable {

    /// return already joined metadata details object
    var featherMetadata: FeatherMetadata {
        try! joined(WebMetadataModel.self).featherMetadata
    }

    /// query metadata relation and load the metadata details
    static func findMetadata(for id: UUID, on db: Database) async throws -> FeatherMetadata? {
        guard let metadata = try await findMetadataBy(id: id, on: db) else {
            return nil
        }
        return metadata.featherMetadata
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
    

    func patchMetadata(_ req: Request, _ block: @escaping () -> Web.Metadata.Patch) async throws {
        guard let metadata = try await Self.findMetadataBy(id: self.uuid, on: req.db) else {
            throw Abort(.notFound)
        }
        try await WebMetadataApiController().patchInput(req, metadata, block())
        try await metadata.update(on: req.db)
    }

    func publishMetadata(_ req: Request) async throws {
        try await patchMetadata(req) {
            .init(status: .published)
        }
    }

    func publishMetadataAsHome(_ req: Request) async throws {
        try await patchMetadata(req) {
            .init(slug: "", status: .published)
        }
    }
}


public extension AdminController where DatabaseModel: MetadataRepresentable {
    
    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: ApiModel.permission(for: .update).key),
            LinkContext(label: "Preview",
                        path: model.featherMetadata.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Metadata",
                        path: "/admin/web/metadatas/" + model.featherMetadata.id.string + "/update/",
                        absolute: true,
                        permission: Web.Metadata.permission(for: .update).key),
        ]
    }

    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: ApiModel.permission(for: .detail).key),
            LinkContext(label: "Preview",
                        path: model.featherMetadata.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Metadata",
                        path: "/admin/web/metadatas/" + model.featherMetadata.id.string + "/update/",
                        absolute: true,
                        permission: Web.Metadata.permission(for: .update).key),
        ]
    }
}

