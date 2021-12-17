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
//            Model.FieldKeys.v1.key,
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
//            \.$key ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.title.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: Self.detailLink(model.title ?? "", id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
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
