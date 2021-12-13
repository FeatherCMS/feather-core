//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

import Vapor
import Fluent

struct UserAccountAdminController: AdminController {

    typealias Model = UserAccountModel
    
    typealias CreateModelEditor = UserAccountEditor
    typealias UpdateModelEditor = UserAccountEditor
    
    typealias ListModelApi = UserAccountApi
    typealias DetailModelApi = UserAccountApi
    typealias CreateModelApi = UserAccountApi
    typealias UpdateModelApi = UserAccountApi
    typealias PatchModelApi = UserAccountApi
    typealias DeleteModelApi = UserAccountApi

    // MARK: - list

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.email,
        ],
        defaultSort: .asc)
    }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$email ~~ term,
        ]
    }

    func listContext(_ req: Request, _ list: ListContainer<Model>) -> AdminListPageContext {
        let rows = list.items.map {
            RowContext(id: $0.identifier, cells: [
                .init($0.email),
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
            .init(label: "Email", value: model.email),
            .init(label: "Has root access?", value: model.isRoot ? "Yes" : "No"),
//            .init(label: "Roles", value: model.roles.map(\.name).joined(separator: "<br>")),
        ])
    }
    
    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.email, type: "user", form: form.context(req))
    }
}
