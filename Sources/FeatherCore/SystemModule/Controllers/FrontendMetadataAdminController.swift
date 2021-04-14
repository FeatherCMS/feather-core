//
//  FrontendContentAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//




struct FrontendMetadataModelAdminController: AdminViewController {
    
    typealias Module = SystemModule
    typealias Model = SystemMetadataModel
    typealias CreateForm = SystemMetadataEditForm
    typealias UpdateForm = SystemMetadataEditForm

//    var listAllowedOrders: [FieldKey] = [
//        SystemMetadataModel.FieldKeys.slug,
//        SystemMetadataModel.FieldKeys.module,
//        SystemMetadataModel.FieldKeys.model,
//    ]
//
//    func listQuery(search: String, queryBuilder: QueryBuilder<SystemMetadataModel>, req: Request) {
//        queryBuilder.filter(\.$slug ~~ search)
//        queryBuilder.filter(\.$title ~~ search)
//    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: [])
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.title ?? "",
              type: "metadata",
              list: .init(title: "Metadatas", url: "/admin/system/metadatas")
        )
    }
}
