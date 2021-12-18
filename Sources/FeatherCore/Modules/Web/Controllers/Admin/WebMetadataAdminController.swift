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
        
    // TODO: solve this code duplication somehow...
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: listCells(for: $0))
        }
        let table = TableContext(id: [Model.Module.moduleKey, Model.modelKey.singular, "table"].joined(separator: "-"),
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    Self.updateTableAction(),
                                 ],
                                 options: .init(allowedOrders: listConfig.allowedOrders.map(\.description),
                                                defaultSort: listConfig.defaultSort))

        return .init(title: Self.modelName.plural.uppercasedFirst,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     breadcrumbs: [
                        Self.moduleLink(Self.moduleName.uppercasedFirst),
                     ])
    }
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        let path = [
            Feather.config.paths.admin,
            model.module,
            model.model,
            model.reference.string,
            Self.updatePathComponent.description
        ].map { PathComponent(stringLiteral: $0) }.path
        
        return .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.updateLink(id: model.uuid),
                    .init(label: "Preview", url: model.slug.safePath(), isBlank: true),
                    .init(label: "Reference", url: path),
              ],
              actions: [
                    Self.deleteLink(id: model.uuid),
              ])
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
        let path = [
            Feather.config.paths.admin,
            editor.model.module,
            editor.model.model,
            editor.model.reference.string,
            Self.updatePathComponent.description
        ].map { PathComponent(stringLiteral: $0) }.path
        
        return .init(title: "Update " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: [
                    Self.moduleLink(Self.moduleName.uppercasedFirst),
                    Self.listLink(Self.modelName.plural.uppercasedFirst),
              ],
              links: [
                    Self.detailLink(id: editor.model.uuid),
                    .init(label: "Preview", url: editor.model.slug.safePath()),
                    .init(label: "Reference", url: path),
              ])
    }
}
