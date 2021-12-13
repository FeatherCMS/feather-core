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

    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: [
                .init($0.name),
            ])
        }
        let table = TableContext(id: "",
                                 columns: [
                                    .init("email", isDefault: true),
                                 ],
                                 rows: rows,
                                 actions: [
                                    .init(label: "Update", url: "/update/", permission: Model.permission(.update).rawValue),
                                    .init(label: "Delete", url: "/delete/", permission: Model.permission(.delete).rawValue),
                                 ])

        return AdminListPageContext(title: "Model.name.plural",
                                    isSearchable: listConfig.isSearchable,
                                    table: table,
                                    pagination: list.info)
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