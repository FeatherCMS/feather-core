//
//  FrontendContentAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//




struct FrontendMetadataModelAdminController: FeatherAdminViewController {
    
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
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }
}
