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
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: [])
    }
    
    func beforeDelete(req: Request, model: SystemMenuModel) -> EventLoopFuture<SystemMenuModel> {
        SystemMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "metadata",
              list: .init(title: "Metadatas", url: "/admin/system/metadatas")
        )
    }
}
