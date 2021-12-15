//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import Fluent

struct CommonVariableAdminController: AdminController {
    
    typealias Model = CommonVariableModel
    
    typealias CreateModelEditor = CommonVariableEditor
    typealias UpdateModelEditor = CommonVariableEditor
    
    typealias ListModelApi = CommonVariableApi
    typealias DetailModelApi = CommonVariableApi
    typealias CreateModelApi = CommonVariableApi
    typealias UpdateModelApi = CommonVariableApi
    typealias PatchModelApi = CommonVariableApi
    typealias DeleteModelApi = CommonVariableApi
    
    // MARK: - list
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.key,
            Model.FieldKeys.v1.name,
            Model.FieldKeys.v1.value,
        ], defaultSort: .asc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$key ~~ term,
            \.$name ~~ term,
            \.$value ~~ term,
            \.$notes ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.key.description, isDefault: true),
            .init(Model.FieldKeys.v1.value.description),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.key, link: detailLink(model.key, id: model.uuid)),
            .init(model.value),
        ]
    }
    
    // MARK: - detail
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: "Variable details", fields: [
            .init(label: "Id", value: model.identifier),
            .init(label: "Key", value: model.key),
            .init(label: "Name", value: model.name),
            .init(label: "Value", value: model.value ?? ""),
            .init(label: "Notes", value: model.notes ?? ""),
        ])
    }

    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.name, type: "variable", form: form.context(req))
    }
}
