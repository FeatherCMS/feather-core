//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct UserPermissionAdminController: AdminController {

    typealias Model = UserPermissionModel
    
    typealias CreateModelEditor = UserPermissionEditor
    typealias UpdateModelEditor = UserPermissionEditor
    
    typealias ListModelApi = UserPermissionApi
    typealias DetailModelApi = UserPermissionApi
    typealias CreateModelApi = UserPermissionApi
    typealias UpdateModelApi = UserPermissionApi
    typealias PatchModelApi = UserPermissionApi
    typealias DeleteModelApi = UserPermissionApi

    // MARK: - list

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.name,
        ],
        defaultSort: .asc)
    }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$name ~~ term,
        ]
    }

    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.name.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.name, link: detailLink(model.name, id: model.uuid)),
        ]
    }
    
    // MARK: - detail
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: "Account details", fields: [
            .init(label: "Id", value: model.identifier),
            .init(label: "Email", value: model.name),
        ])
    }
    
    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.name, type: "permission", form: form.context(req))
    }
}
