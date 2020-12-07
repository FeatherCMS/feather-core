//
//  MenuAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMenuItemAdminController: ViperAdminViewController {

    typealias Module = FrontendModule
    typealias Model = FrontendMenuItemModel
    typealias CreateForm = FrontendMenuItemEditForm
    typealias UpdateForm = FrontendMenuItemEditForm

    var idParamKey: String { "itemId" }
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.label,
        Model.FieldKeys.url,
        Model.FieldKeys.priority,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<FrontendMenuItemModel>, req: Request) {
        queryBuilder.filter(\.$label ~~ search)
        queryBuilder.filter(\.$url ~~ search)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<FrontendMenuItemModel>) -> QueryBuilder<FrontendMenuItemModel> {
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$menu.$id == uuid)
    }
}
