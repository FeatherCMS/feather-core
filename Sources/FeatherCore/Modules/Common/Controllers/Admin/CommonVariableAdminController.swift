//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

struct CommonVariableAdminController: AdminController {
    typealias ApiModel = Common.Variable
    typealias DatabaseModel = CommonVariableModel
    
    typealias CreateModelEditor = CommonVariableEditor
    typealias UpdateModelEditor = CommonVariableEditor
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "key",
            "name",
            "value",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
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
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.key, link: LinkContext(label: model.key, permission: ApiModel.permission(for: .detail).key)),
            .init(model.value),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("key", model.key),
            .init("name", model.name),
            .init("value", model.value),
            .init("notes", model.notes),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.name
    }
}
