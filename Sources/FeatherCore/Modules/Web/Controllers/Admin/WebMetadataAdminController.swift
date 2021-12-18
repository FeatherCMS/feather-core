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
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.slug
    }
    
    // MARK: - metadata context
        
    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: listCells(for: $0))
        }
        let table = TableContext(id: [Model.Module.moduleKey, Model.modelKey, "table"].joined(separator: "-"),
                                 columns: listColumns(),
                                 rows: rows,
                                 actions: [
                                    Self.updateTableAction(),
                                 ])

        return .init(title: Self.modelName.plural.uppercasedFirst,
                     isSearchable: listConfig.isSearchable,
                     table: table,
                     pagination: list.info,
                     breadcrumbs: [
                        Self.moduleLink(Self.moduleName.uppercasedFirst),
                     ])
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
        let path = [
            Feather.config.paths.admin,
            editor.model.module,
            editor.model.model,
            editor.model.reference.uuidString,
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
