//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct WebMenuItemAdminController: AdminController {
    typealias ApiModel = Web.MenuItem
    typealias DatabaseModel = WebMenuItemModel
    
    typealias CreateModelEditor = WebMenuItemEditor
    typealias UpdateModelEditor = WebMenuItemEditor

    
    static var modelName: FeatherModelName = .init(singular: "item")

    func listQuery(_ req: Request, _ qb: QueryBuilder<DatabaseModel>) async throws -> QueryBuilder<DatabaseModel> {
        guard let id = Web.Menu.getIdParameter(req) else {
            return qb
        }
        return qb.filter(\.$menu.$id == id)
    }
    
    func beforeCreate(_ req: Request, model: DatabaseModel) async throws {
        guard let id = Web.Menu.getIdParameter(req) else {
            throw Abort(.badRequest)
        }
        model.$menu.id = id
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "label",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$label ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("label"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.label, link: LinkContext(label: model.label, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [FieldContext] {
        [
            .init("id", model.uuid.string),
            .init("icon", model.icon),
            .init("label", model.label),
            .init("url", model.url),
            .init("target", "Open in " + (model.isBlank ? "new" : "same") + " window / tab"),
            .init("permission", model.permission),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.label
    }
    

    // NOTE: simplify this after we've got a pattern.

    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes
            .grouped(Web.pathKey.pathComponent)
            .grouped(Web.Menu.pathKey.pathComponent)
            .grouped(Web.Menu.pathIdComponent)
            .grouped(ApiModel.pathKey.pathComponent)
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: WebModule.featherIdentifier.uppercasedFirst,
                        dropLast: 3,
                        permission: nil), //Model.Module.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: Web.Menu.permission(for: .list).key),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 1,
                        permission: Web.Menu.permission(for: .detail).key),
        ]
    }
    
    func detailBreadcrumbs(_ req: Request, _ model: WebMenuItemModel) -> [LinkContext] {
        [
            LinkContext(label: WebModule.featherIdentifier.uppercasedFirst,
                        dropLast: 4,
                        permission: nil), //Model.Module.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: Web.Menu.permission(for: .list).key),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: Web.Menu.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: WebMenuItemModel) -> [LinkContext] {
        [
            LinkContext(label: WebModule.featherIdentifier.uppercasedFirst,
                        dropLast: 5,
                        permission: nil), //Model.Module.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 4,
                        permission: Web.Menu.permission(for: .list).key),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 3,
                        permission: Web.Menu.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: WebModule.featherIdentifier.uppercasedFirst,
                        dropLast: 4,
                        permission: nil), //Model.Module.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: Web.Menu.permission(for: .list).key),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: Web.Menu.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
}
