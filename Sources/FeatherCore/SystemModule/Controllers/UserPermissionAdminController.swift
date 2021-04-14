//
//  UserPermissionAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//




struct UserPermissionAdminController: AdminViewController {
    
    typealias Module = SystemModule
    typealias Model = SystemPermissionModel
    typealias CreateForm = SystemPermissionEditForm
    typealias UpdateForm = SystemPermissionEditForm

//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.name,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<SystemPermissionModel>, req: Request) {
//        queryBuilder.filter(\.$name ~~ search)
//        queryBuilder.filter(\.$namespace ~~ search)
//        queryBuilder.filter(\.$context ~~ search)
//        queryBuilder.filter(\.$action ~~ search)
//    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"], rows: models.map { model in
            TableRow(id: model.id!.uuidString, cells: [TableCell(model.name)])
        })
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

