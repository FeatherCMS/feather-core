//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct SystemMenuItemController: FeatherController {

    typealias Module = SystemModule
    typealias Model = SystemMenuItemModel
    
    typealias CreateForm = SystemMenuItemEditForm
    typealias UpdateForm = SystemMenuItemEditForm
    
    typealias GetApi = SystemVariableApi
    typealias ListApi = SystemVariableApi
    typealias CreateApi = SystemVariableApi
    typealias UpdateApi = SystemVariableApi
    typealias PatchApi = SystemVariableApi
    typealias DeleteApi = SystemVariableApi

    func setupRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(SystemModule.idKeyPathComponent)
                          .grouped(SystemMenuModel.idKeyPathComponent)
                          .grouped(SystemMenuModel.idParamKeyPathComponent)
                          .grouped(Model.idKeyPathComponent)
        
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
        let menuId = SystemMenuModel.getIdParameter(req: req)!

        return ListContext(info: Model.info(req), table: table, pages: pages, nav: [
            .init(label: "Menu details", url: "/admin/system/menus/" + menuId.uuidString + "/")
        ], breadcrumb: [
            .init(label: "System", url: "/admin/system/"),
            .init(label: "Menus", url: "/admin/system/menus/"),
            .init(label: "Menu", url: "/admin/system/menus/" + menuId.uuidString + "/"),
            .init(label: "Items", url: req.url.path.safePath()),
        ])
    }
    
    func beforeCreate(req: Request, model: SystemMenuItemModel) -> EventLoopFuture<SystemMenuItemModel> {
        guard let menuId = SystemMenuModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        model.$menu.id = menuId
        return req.eventLoop.future(model)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<SystemMenuItemModel>) -> QueryBuilder<SystemMenuItemModel> {
        guard let menuId = SystemMenuModel.getIdParameter(req: req) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$menu.$id == menuId)
    }
    
    
    
    func detailFields(req: Request, model: SystemMenuItemModel) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Icon", value: model.icon ?? ""),
            .init(label: "Label", value: model.label),
            .init(label: "Url", value: model.url),
            .init(label: "Target", value: "Open in " + (model.isBlank ? "new" : "same") + " window / tab"),
            .init(label: "Permission", value: model.permission ?? ""),
        ]
    }
    
    #warning("fixme")
    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [], bc: [
            //list: .init(label: "Menu items", url: "/admin/frontend/menus/" + model.$menu.id.uuidString + "/items/"),
        ])
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.label,
              type: "menu item",
              list: .init(label: "Menu items", url: "/admin/frontend/menus/" + model.$menu.id.uuidString + "/items/")
        )
    }

    
}
