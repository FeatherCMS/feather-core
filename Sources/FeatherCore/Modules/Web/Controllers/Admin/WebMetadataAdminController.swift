//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMetadataAdminController: AdminController {
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
            .init(model.title, link: LinkContext(label: model.title ?? "Details", permission: Self.detailPermission())),
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

    func detailLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: Self.updatePermission()),
            // NOTE: store permission for the metadata reference?
            LinkContext(label: "Preview",
                        path: model.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Reference",
                        path: "/admin/" + model.module + "/" + model.model + "/" + model.reference.string + "/update/",
                        absolute: true,
                        permission: nil),
        ]
    }

    func updateLinks(_ req: Request, _ model: Model) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: Self.detailPermission()),
            LinkContext(label: "Preview",
                        path: model.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            LinkContext(label: "Reference",
                        path: "/admin/" + model.module + "/" + model.model + "/" + model.reference.string + "/update/",
                        absolute: true,
                        permission: nil),
        ]
    }
}
