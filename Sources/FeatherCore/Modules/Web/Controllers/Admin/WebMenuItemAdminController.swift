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
    
    static var modulePathComponents: [PathComponent] {
        [
            Feather.config.paths.admin.pathComponent,
            Model.Module.pathComponent,
            WebMenuModel.pathComponent,
            WebMenuModel.idPathComponent
        ]
    }
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        routes
            .grouped(WebModule.pathComponent)
            .grouped(WebMenuModel.pathComponent)
            .grouped(WebMenuModel.idPathComponent)
            .grouped(Model.pathComponent)
    }
    
    func listNavigation(_ req: Request) -> [LinkContext] {
        guard let menuId = WebMenuModel.getIdParameter(req: req) else {
            return []
        }
        let path = WebMenuAdminController.detailPath(for: menuId) + "/items/create"
        return [
            LinkContext(label: "Create", url: path)
        ]
    }

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
            .init(model.label, link: Self.detailLink(model.label, id: model.uuid)),
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
    

    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            WebMenuAdminController.moduleLink(),
        ]
    }
   
    
    
}
