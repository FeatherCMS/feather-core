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

    
    func findBy(_ id: UUID, on db: Database) async throws -> Model {
        try await Model.findWithRolesBy(id: id, on: db)
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.email,
        ])
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
            .init(model.email, link: Self.detailLink(model.email, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Email", value: model.email),
            .init(label: "Has root access?", value: model.isRoot ? "Yes" : "No"),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.email
    }
}
