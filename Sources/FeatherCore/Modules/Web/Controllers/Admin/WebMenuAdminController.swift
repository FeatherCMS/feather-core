//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct WebMenuAdminController: AdminController {
    typealias ApiModel = Web.Menu
    typealias DatabaseModel = WebMenuModel
    
    typealias CreateModelEditor = WebMenuEditor
    typealias UpdateModelEditor = WebMenuEditor
    
    func findBy(_ id: UUID, on db: Database) async throws -> DatabaseModel {
        try await DatabaseModel.findWithItemsBy(id: id, on: db)
    }

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "key",
            "name",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$key ~~ term,
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("key"),
            .init("name"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.key, link: LinkContext(label: model.key, permission: ApiModel.permission(for: .detail).key)),
            .init(model.name, link: LinkContext(label: model.name, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("key", model.key),
            .init("name", model.name),
            .init("notes", model.notes),
        ]
    }
    
    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: Self.updatePathComponent.description,
                        permission: ApiModel.permission(for: .update).key),
            LinkContext(label: WebMenuItemAdminController.modelName.plural,
                        path: Web.MenuItem.pathKey,
                        permission: Web.MenuItem.permission(for: .list).key),
        ]
    }
    
    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: ApiModel.permission(for: .detail).key),
            LinkContext(label: WebMenuItemAdminController.modelName.plural,
                        path: Web.MenuItem.pathKey,
                        dropLast: 1,
                        permission: Web.MenuItem.permission(for: .list).key),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.key
    }
}
