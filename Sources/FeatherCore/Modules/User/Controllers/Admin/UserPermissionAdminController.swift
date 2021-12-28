//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct UserPermissionAdminController: AdminController {
    typealias ApiModel = User.Permission
    typealias DatabaseModel = UserPermissionModel
    
    typealias CreateModelEditor = UserPermissionEditor
    typealias UpdateModelEditor = UserPermissionEditor

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            DatabaseModel.FieldKeys.v1.name,
        ])
    }

    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$name ~~ term,
        ]
    }

    func listColumns() -> [ColumnContext] {
        [
            .init(DatabaseModel.FieldKeys.v1.name.description),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.name, link: LinkContext(label: model.name, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
        
    func detailFields(for model: DatabaseModel) -> [FieldContext] {
        [
            .init("id", model.uuid.string),
            .init("namespace", model.namespace),
            .init("context", model.context),
            .init("action", model.action),
            .init("name", model.name),
            .init("notes", model.notes),
        ]
    }

    func deleteInfo(_ model: DatabaseModel) -> String {
        model.name
    }
}
