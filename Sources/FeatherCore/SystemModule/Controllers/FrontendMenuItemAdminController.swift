//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//




struct FrontendMenuItemAdminController: FeatherAdminViewController {

    typealias Module = SystemModule
    typealias Model = SystemMenuItemModel
    typealias CreateForm = SystemMenuItemEditForm
    typealias UpdateForm = SystemMenuItemEditForm

    var idParamKey: String { "itemId" }
    
//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.label,
//        Model.FieldKeys.url,
//        Model.FieldKeys.priority,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<SystemMenuItemModel>, req: Request) {
//        queryBuilder.filter(\.$label ~~ search)
//        queryBuilder.filter(\.$url ~~ search)
//    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<SystemMenuItemModel>) -> QueryBuilder<SystemMenuItemModel> {
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$menu.$id == uuid)
    }
}
