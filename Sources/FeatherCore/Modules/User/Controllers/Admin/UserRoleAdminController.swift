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
            .init(model.name, link: Self.detailLink(model.name, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Key", value: model.key),
            .init(label: "Name", value: model.name),
            .init(label: "Notes", value: model.notes),
            .init(label: "Permissions", value: model.permissions.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
    
}
