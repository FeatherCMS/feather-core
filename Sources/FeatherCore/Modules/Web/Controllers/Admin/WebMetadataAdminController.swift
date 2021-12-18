//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMetadataController: AdminController {
    typealias Model = WebMetadataModel
    
    typealias CreateModelEditor = WebMetadataEditor
    typealias UpdateModelEditor = WebMetadataEditor
    
    typealias ListModelApi = WebMetadataApi
    typealias DetailModelApi = WebMetadataApi
    typealias CreateModelApi = WebMetadataApi
    typealias UpdateModelApi = WebMetadataApi
    typealias PatchModelApi = WebMetadataApi
    typealias DeleteModelApi = WebMetadataApi
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "title",
            "module",
            "model",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
            .init("module"),
            .init("model"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: Self.detailLink(model.title ?? "Details", id: model.uuid)),
            .init(model.module),
            .init(model.model),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("module", model.module),
            .init("model", model.model),
            .init("reference", model.reference.string),
            .init("slug", model.slug),
            .init("status", model.status.rawValue),
            .init("date", model.date.description),
            .init("title", model.title),
            .init("excerpt", model.excerpt),
            .init("image", model.imageKey, type: .image),
            .init("feed", model.feedItem ? "Yes" : "No", label: "Feed item?"),
            .init("canonical", model.canonicalUrl, label: "Canonical URL"),
            .init("css", model.css),
            .init("js", model.js),
            .init("filters", model.filters.joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.slug
    }
    
    // MARK: - metadata context
    
    func listNavigation(_ req: Request) -> [LinkContext] {
        []
    }
    
    private func referencePath(_ model: Model) -> String {
        [
            Feather.config.paths.admin,
            model.module,
            model.model,
            model.reference.string,
            Self.updatePathComponent.description
        ].map { PathComponent(stringLiteral: $0) }.path
    }

    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            Self.updateLink(id: model.uuid),
            .init(label: "Preview", url: model.slug.safePath(), isBlank: true),
            .init(label: "Reference", url: referencePath(model)),
        ]
    }
    
    func updateLinks(_ req: Request, _ model: WebMetadataModel) -> [LinkContext] {
        [
            Self.detailLink(id: model.uuid),
            .init(label: "Preview", url: model.slug.safePath()),
            .init(label: "Reference", url: referencePath(model)),
        ]
    }
}
