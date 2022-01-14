//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct UserRoleAdminController: AdminController {
    typealias ApiModel = User.Role
    typealias DatabaseModel = UserRoleModel
    
    typealias CreateModelEditor = UserRoleEditor
    typealias UpdateModelEditor = UserRoleEditor

    func findBy(_ id: UUID, on db: Database) async throws -> DatabaseModel {
        try await DatabaseModel.findWithPermissionsBy(id: id, on: db)
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "name"
        ],
        defaultSort: .asc)
    }

    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("name"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.name, link: LinkContext(label: model.name, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("key", model.key),
            .init("name", model.name),
            .init("notes", model.notes),
            .init("permissions", model.permissions.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.name
    }
    
}
