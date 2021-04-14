//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

//
//struct FrontendMenuItemAdminController: AdminViewController {
//
//    typealias Module = SystemModule
//    typealias Model = SystemMenuItemModel
//    typealias CreateForm = SystemMenuItemEditForm
//    typealias UpdateForm = SystemMenuItemEditForm
//
//    var idParamKey: String { "itemId" }
//    
////    "title": "Menu items",
////    "key": "system.menuItems",
////    "fields": [
////        ["key": "label", "default": true]
////    ],
////    "nav": [
////        ["label": "Menu", "link": "/admin/frontend/menus/" + menuId]
////    ]
//    func listTable(_ models: [Model]) -> Table {
//        Table(columns: [])
//    }
//
////    var listAllowedOrders: [FieldKey] = [
////        Model.FieldKeys.label,
////        Model.FieldKeys.url,
////        Model.FieldKeys.priority,
////    ]
////
////    func listQuery(search: String, queryBuilder: QueryBuilder<SystemMenuItemModel>, req: Request) {
////        queryBuilder.filter(\.$label ~~ search)
////        queryBuilder.filter(\.$url ~~ search)
////    }
//
//    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<SystemMenuItemModel>) -> QueryBuilder<SystemMenuItemModel> {
//        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
//            return queryBuilder
//        }
//        return queryBuilder.filter(\.$menu.$id == uuid)
//    }
//    
//    
//    func getContext(req: Request, model: Model) -> GetViewContext {
//        .init(title: "Menu item",
//              key: "system.menuItems",
//              list: .init(label: "Menu items", url: "/admin/frontend/menus/" + model.$menu.id.uuidString + "/items/"),
//              nav: [],
//              fields: [
//                .init(label: "Id", value: model.id!.uuidString),
//                .init(label: "Icon", value: model.icon ?? ""),
//                .init(label: "Label", value: model.label),
//                .init(label: "Url", value: model.url),
//                .init(label: "Target", value: "Open in " + (model.isBlank ? "new" : "same") + " window / tab"),
//                .init(label: "Permission", value: model.permission ?? ""),
//              ])
//    }
//    
//    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
//        .init(id: formId,
//              token: formToken,
//              context: model.label,
//              type: "menu item",
//              list: .init(label: "Menu items", url: "/admin/frontend/menus/" + model.$menu.id.uuidString + "/items/")
//        )
//    }
//}
