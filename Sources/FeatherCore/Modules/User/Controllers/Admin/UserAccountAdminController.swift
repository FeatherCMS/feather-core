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

    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.email.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.email, link: detailLink(model.email, id: model.uuid)),
        ]
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
