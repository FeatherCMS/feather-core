//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMenuItemController: FeatherController {

    typealias Module = FrontendModule
    typealias Model = FrontendMenuItemModel
    
    typealias CreateForm = FrontendMenuItemEditForm
    typealias UpdateForm = FrontendMenuItemEditForm
    
    typealias GetApi = FrontendMenuItemApi
    typealias ListApi = FrontendMenuItemApi
    typealias CreateApi = FrontendMenuItemApi
    typealias UpdateApi = FrontendMenuItemApi
    typealias PatchApi = FrontendMenuItemApi
    typealias DeleteApi = FrontendMenuItemApi

    func setupRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Module.moduleKeyPathComponent)
                          .grouped(FrontendMenuModel.modelKeyPathComponent)
                          .grouped(FrontendMenuModel.idParamKeyPathComponent)
                          .grouped(Model.modelKeyPathComponent)
        
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: Model.createPathComponent)
        setupUpdateRoutes(on: base, as: Model.updatePathComponent)
        setupDeleteRoutes(on: base, as: Model.deletePathComponent)
    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["label", "url"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.label), TableCell(model.url)])
        })
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        let menuId = FrontendMenuModel.getIdParameter(req: req)!

        return ListContext(info: Model.info(req), table: table, pages: pages, nav: [
            .init(label: "Menu details", url: "/admin/frontend/menus/" + menuId.uuidString + "/")
        ], breadcrumb: [
            .init(label: "Frontend", url: "/admin/frontend/"),
            .init(label: "Menus", url: "/admin/frontend/menus/"),
            .init(label: "Menu", url: "/admin/frontend/menus/" + menuId.uuidString + "/"),
            .init(label: "Items", url: req.url.path.safePath()),
        ])
    }
    
    func beforeCreate(req: Request, model: FrontendMenuItemModel) -> EventLoopFuture<FrontendMenuItemModel> {
        guard let menuId = FrontendMenuModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        model.$menu.id = menuId
        return req.eventLoop.future(model)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<FrontendMenuItemModel>) -> QueryBuilder<FrontendMenuItemModel> {
        guard let menuId = FrontendMenuModel.getIdParameter(req: req) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$menu.$id == menuId)
    }
    
    func detailFields(req: Request, model: FrontendMenuItemModel) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Icon", value: model.icon ?? ""),
            .init(label: "Label", value: model.label),
            .init(label: "Url", value: model.url),
            .init(label: "Target", value: "Open in " + (model.isBlank ? "new" : "same") + " window / tab"),
            .init(label: "Permission", value: model.permission ?? ""),
        ]
    }

    func getContext(req: Request, model: Model) -> DetailContext {
        let menuId = FrontendMenuModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [], bc: [
            .init(label: "Frontend", url: "/admin/frontend/"),
            .init(label: "Menus", url: "/admin/frontend/menus/"),
            .init(label: "Menu", url: "/admin/frontend/menus/" + menuId.uuidString + "/"),
            .init(label: "Items", url: "/admin/frontend/menus/" + menuId.uuidString + "/items/"),
            .init(label: "View", url: req.url.path.safePath()),
        ])
    }
    
    func deleteContext(req: Request, model: FrontendMenuItemModel) -> String {
        model.label
    }
    
    func deleteContext(req: Request, id: String, token: String, model: FrontendMenuItemModel) -> DeleteContext {
        let menuId = FrontendMenuModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), id: id, token: token, context: deleteContext(req: req, model: model), bc: [
            .init(label: "Frontend", url: "/admin/frontend/"),
            .init(label: "Menus", url: "/admin/frontend/menus/"),
            .init(label: "Menu", url: "/admin/frontend/menus/" + menuId.uuidString + "/"),
            .init(label: "Items", url: "/admin/frontend/menus/" + menuId.uuidString + "/items/"),
            .init(label: "Delete", url: req.url.path.safePath()),
        ])
    }
}
