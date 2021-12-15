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
    
    // MARK: - list
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
//            Model.FieldKeys.v1.key,
//            Model.FieldKeys.v1.name,
//            Model.FieldKeys.v1.value,
        ], defaultSort: .asc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
//            \.$key ~~ term,
//            \.$name ~~ term,
//            \.$value ~~ term,
//            \.$notes ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.title.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: detailLink(model.title ?? "", id: model.uuid)),
        ]
    }
    
    // MARK: - detail
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: "Variable details", fields: [
            .init(label: "Id", value: model.identifier),
//            .init(label: "Key", value: model.key),
//            .init(label: "Name", value: model.name),
//            .init(label: "Value", value: model.value ?? ""),
//            .init(label: "Notes", value: model.notes ?? ""),
        ])
    }

    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.slug, type: "metadata", form: form.context(req))
    }
}
