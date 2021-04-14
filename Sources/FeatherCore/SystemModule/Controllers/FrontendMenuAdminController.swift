//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//




struct FrontendMenuAdminController: AdminViewController {
//
    typealias Module = SystemModule
    typealias Model = SystemMenuModel
    typealias CreateForm = SystemMenuEditForm
    typealias UpdateForm = SystemMenuEditForm

//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.name,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<SystemMenuModel>, req: Request) {
//        queryBuilder.filter(\.$key ~~ search)
//        queryBuilder.filter(\.$name ~~ search)
//    }
    
    
//        "title": "Menus",
//        "key": "frontend.menus",
//        "fields": [
//            ["key": "name", "default": true]
//        ],
//        "actions": []
//
//
//    #if(UserHasPermission("system.menuItems.list")):
//        #(table.actions.append(["link": "/items/", "label": "Items", "icon": "link", "width": "4rem"]))
//    #endif
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: [])
    }
    
    func beforeDelete(req: Request, model: SystemMenuModel) -> EventLoopFuture<SystemMenuModel> {
        SystemMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
    }

    func getContext(req: Request, model: Model) -> GetViewContext {
        .init(title: "Menu",
              key: "system.menus",
              list: .init(label: "Menus", url: "/admin/system/menus/"),
              nav: [
                .init(label: "Menu items", url: "/admin/system/menus/" + model.id!.uuidString + "/items/")
              ],
              fields: [
                .init(label: "Id", value: model.id!.uuidString),
                .init(label: "Key", value: model.key),
                .init(label: "Name", value: model.name),
                .init(label: "Notes", value: model.notes ?? ""),
              ])
    }

    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "menu",
              list: .init(label: "Menus", url: "/admin/system/menus")
        )
    }
}
