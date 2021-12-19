//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMenuItemAdminController: AdminController {
    typealias Model = WebMenuItemModel
    
    typealias CreateModelEditor = WebMenuItemEditor
    typealias UpdateModelEditor = WebMenuItemEditor
    
    typealias ListModelApi = WebMenuItemApi
    typealias DetailModelApi = WebMenuItemApi
    typealias CreateModelApi = WebMenuItemApi
    typealias UpdateModelApi = WebMenuItemApi
    typealias PatchModelApi = WebMenuItemApi
    typealias DeleteModelApi = WebMenuItemApi
    
    static var modelName: FeatherModelName = .init(singular: "menu item")

    func listQuery(_ req: Request, _ qb: QueryBuilder<Model>) -> QueryBuilder<Model> {
        guard let menuId = WebMenuModel.getIdParameter(req: req) else {
            return qb
        }
        return qb.filter(\.$menu.$id == menuId)
    }
    
    func beforeCreate(_ req: Request, model: Model) async throws {
        guard let menuId = WebMenuModel.getIdParameter(req: req) else {
            throw Abort(.badRequest)
        }
        model.$menu.id = menuId
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "label",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$label ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("label"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.label, link: LinkContext(label: model.label, permission: Self.detailPermission())),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("icon", model.icon),
            .init("label", model.label),
            .init("url", model.url),
            .init("target", "Open in " + (model.isBlank ? "new" : "same") + " window / tab"),
            .init("permission", model.permission),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.label
    }
    

    // NOTE: simplify this after we've got a pattern.

    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes
            .grouped(WebModule.pathComponent)
            .grouped(WebMenuModel.pathComponent)
            .grouped(WebMenuModel.idPathComponent)
            .grouped(Model.pathComponent)
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: WebModule.moduleKey.uppercasedFirst,
                        dropLast: 3,
                        permission: WebModule.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: WebMenuAdminController.listPermission()),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 1,
                        permission: WebMenuAdminController.detailPermission()),
        ]
    }
    
    func detailBreadcrumbs(_ req: Request, _ model: WebMenuItemModel) -> [LinkContext] {
        [
            LinkContext(label: WebModule.moduleKey.uppercasedFirst,
                        dropLast: 4,
                        permission: WebModule.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: WebMenuAdminController.listPermission()),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: WebMenuAdminController.detailPermission()),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: Self.listPermission()),
        ]
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: WebMenuItemModel) -> [LinkContext] {
        [
            LinkContext(label: WebModule.moduleKey.uppercasedFirst,
                        dropLast: 5,
                        permission: WebModule.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 4,
                        permission: WebMenuAdminController.listPermission()),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 3,
                        permission: WebMenuAdminController.detailPermission()),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: Self.listPermission()),
        ]
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: WebModule.moduleKey.uppercasedFirst,
                        dropLast: 4,
                        permission: WebModule.permission.key),
            LinkContext(label: WebMenuAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: WebMenuAdminController.listPermission()),
            LinkContext(label: WebMenuAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: WebMenuAdminController.detailPermission()),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: Self.listPermission()),
        ]
    }
}
