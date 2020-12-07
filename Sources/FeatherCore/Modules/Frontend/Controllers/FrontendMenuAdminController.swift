//
//  MenuAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMenuAdminController: ViperAdminViewController {

    typealias Module = FrontendModule
    typealias Model = FrontendMenuModel
    typealias CreateForm = FrontendMenuEditForm
    typealias UpdateForm = FrontendMenuEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<FrontendMenuModel>, req: Request) {
        queryBuilder.filter(\.$key ~~ search)
        queryBuilder.filter(\.$name ~~ search)
    }
    
    func beforeDelete(req: Request, model: FrontendMenuModel) -> EventLoopFuture<FrontendMenuModel> {
        FrontendMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
    }
}
