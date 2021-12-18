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
            "email",
        ])
    }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$email ~~ term,
        ]
    }

    func listColumns() -> [ColumnContext] {
        [
            .init("email"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.email, link: Self.detailLink(model.email, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("email", model.email),
            .init("root", model.isRoot ? "Yes" : "No", label: "Has root access?"),
            .init("roles", model.roles.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.email
    }
}
