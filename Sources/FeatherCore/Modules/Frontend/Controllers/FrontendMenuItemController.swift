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
    
    func setupApiRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Module.moduleKeyPathComponent)
                          .grouped(FrontendMenuModel.modelKeyPathComponent)
                          .grouped(FrontendMenuModel.idParamKeyPathComponent)
                          .grouped(Model.modelKeyPathComponent)
        
        setupListApiRoute(on: base)
        setupGetApiRoute(on: base)
        setupCreateApiRoute(on: base)
        setupUpdateApiRoute(on: base)
        setupPatchApiRoute(on: base)
        setupDeleteApiRoute(on: base)
    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["label", "url"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.label), TableCell(model.url)])
        })
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        let menuId = FrontendMenuModel.getIdParameter(req: req)!

        return ListContext(info: Model.info(req), table: table, pages: pages, nav: [
            FrontendMenuModel.adminLink(for: menuId),
        ], breadcrumb: [
            Module.adminLink,
            FrontendMenuModel.adminLink,
            FrontendMenuModel.adminLink(for: menuId),
            .init(label: "Items", url: req.url.path.safePath()),
        ])
    }
    
    func beforeCreate(req: Request, model: Model) -> EventLoopFuture<Model> {
        guard let menuId = FrontendMenuModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        model.$menu.id = menuId
        return req.eventLoop.future(model)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        guard let menuId = FrontendMenuModel.getIdParameter(req: req) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$menu.$id == menuId)
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
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
            Module.adminLink,
            FrontendMenuModel.adminLink,
            FrontendMenuModel.adminLink(for: menuId),
            Model.adminLink(menuId: menuId),
            .init(label: "View", url: req.url.path.safePath()),
        ])
    }
    
    func deleteContext(req: Request, model: Model) -> String {
        model.label
    }
    
    func deleteContext(req: Request, id: String, token: String, model: Model) -> DeleteContext {
        let menuId = FrontendMenuModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), id: id, token: token, context: deleteContext(req: req, model: model), bc: [
            Module.adminLink,
            FrontendMenuModel.adminLink,
            FrontendMenuModel.adminLink(for: menuId),
            Model.adminLink(menuId: menuId),
            .init(label: "Delete", url: req.url.path.safePath()),
        ])
    }
}
