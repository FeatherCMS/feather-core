//
//  FrontendContentAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct FrontendMetadataModelAdminController: ViperAdminViewController {
    
    typealias Module = FrontendModule
    typealias Model = FrontendMetadataModel
    typealias CreateForm = FrontendMetadataModelEditForm
    typealias UpdateForm = FrontendMetadataModelEditForm

    var listAllowedOrders: [FieldKey] = [
        FrontendMetadataModel.FieldKeys.slug,
        FrontendMetadataModel.FieldKeys.module,
        FrontendMetadataModel.FieldKeys.model,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<FrontendMetadataModel>, req: Request) {
        queryBuilder.filter(\.$slug ~~ search)
        queryBuilder.filter(\.$title ~~ search)
    }

    private func path(_ model: Model) -> String {
        let date = DateFormatter.asset.string(from: Date())
        return Model.path + model.id!.uuidString + "_" + date + ".jpg"
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: path(model)).map { model }
    }
}
