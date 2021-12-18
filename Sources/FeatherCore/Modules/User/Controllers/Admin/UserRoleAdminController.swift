//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct UserRoleAdminController: AdminController {
    typealias Model = UserRoleModel
    
    typealias CreateModelEditor = UserRoleEditor
    typealias UpdateModelEditor = UserRoleEditor
    
    typealias ListModelApi = UserRoleApi
    typealias DetailModelApi = UserRoleApi
    typealias CreateModelApi = UserRoleApi
    typealias UpdateModelApi = UserRoleApi
    typealias PatchModelApi = UserRoleApi
    typealias DeleteModelApi = UserRoleApi

    func findBy(_ id: UUID, on db: Database) async throws -> Model {
        try await Model.findWithPermissionsBy(id: id, on: db)
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "name"
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
            .init("name"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.name, link: Self.detailLink(model.name, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("key", model.key),
            .init("name", model.name),
            .init("notes", model.notes),
            .init("permissions", model.permissions.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
    
}
