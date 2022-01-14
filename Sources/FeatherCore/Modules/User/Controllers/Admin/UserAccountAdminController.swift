//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 23..
//

struct UserAccountAdminController: AdminController {
    typealias ApiModel = User.Account
    typealias DatabaseModel = UserAccountModel
    
    typealias CreateModelEditor = UserAccountEditor
    typealias UpdateModelEditor = UserAccountEditor
    
    func findBy(_ id: UUID, on db: Database) async throws -> DatabaseModel {
        try await DatabaseModel.findWithRolesBy(id: id, on: db)
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "email",
        ])
    }

    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$email ~~ term,
        ]
    }

    func listColumns() -> [ColumnContext] {
        [
            .init("email"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.email, link: LinkContext(label: model.email, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("email", model.email),
            .init("root", model.isRoot ? "Yes" : "No", label: "Has root access?"),
            .init("roles", model.roles.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.email
    }
}
