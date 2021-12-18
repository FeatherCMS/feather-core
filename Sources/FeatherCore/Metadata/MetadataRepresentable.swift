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

    func filter(_ content: String, _ req: Request) async -> String {
        let allFilters: [FeatherFilter] = await req.invokeAllFlat("filters")
        let filters = allFilters.filter { metadataDetails.filters.contains($0.key) }.sorted { $0.priority > $1.priority }
        var result = content
        await filters.asyncForEach { filter in
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
        await WebMetadataApi().mapPatch(req, model: metadata, input: block())
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
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.updateLink(id: model.uuid),
                    .init(label: "Preview", url: model.metadataDetails.slug.safePath(), isBlank: true),
                    WebMetadataController.updateLink("Metadata", id: model.metadataDetails.id),
              ],
              actions: [
                    Self.deleteLink(id: model.uuid),
              ])
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
        // TODO: error management...
        let metadata = try! await Model.findMetadataDetails(for: editor.model.uuid, on: req.db)!
        return .init(title: "Update " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.detailLink(id: editor.model.uuid),
                    .init(label: "Preview", url: metadata.slug.safePath(), isBlank: true),
                    WebMetadataController.updateLink("Metadata", id: metadata.id),
              ],
              actions: [
                    Self.deleteLink(id: editor.model.uuid),
              ])
    }
}

