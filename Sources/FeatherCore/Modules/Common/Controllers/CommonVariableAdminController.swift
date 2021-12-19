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
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "key",
            "name",
            "value",
        ])
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
            .init("key"),
            .init("value"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.key, link: LinkContext(label: model.key, permission: Self.detailPermission())),
            .init(model.value),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("key", model.key),
            .init("name", model.name),
            .init("value", model.value),
            .init("notes", model.notes),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
}
