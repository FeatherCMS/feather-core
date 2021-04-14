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

    func getContext(req: Request, model: Model) -> GetViewContext {
        .init(title: "Metadata",
              key: "system.metadatas",
              list: .init(label: "Metadatas", url: "/admin/system/metadatas"),
              nav: [
                .init(label: "Preview", url: model.slug.safePath(), isBlank: true),
                .init(label: "Reference", url: "/admin/" + model.module + "/" + model.model + "/" + model.reference.uuidString + "/"),
              ],
              fields: [
                .init(label: "Id", value: model.id!.uuidString),
                .init(label: "Image", value: model.imageKey ?? ""),
                .init(label: "Title", value: model.title ?? ""),
                .init(label: "Excerpt", value: model.excerpt ?? ""),
                //.init(label: "Date", value: model.excerpt ?? ""),
                //#Date(timeStamp: model.date, fixedFormat: $app.dateFormats.full, timeZone: $app.timezone)
                .init(label: "Slug", value: model.slug),
                .init(label: "Status", value: model.status.localized),
                .init(label: "Is feed item?", value: model.feedItem ? "Yes" : "No"),
                .init(label: "Canonical url", value: model.canonicalUrl ?? ""),
                .init(label: "Filters", value: model.filters.joined(separator: "<br>")),
                .init(label: "CSS", value: model.css ?? ""),
                .init(label: "JS", value: model.js ?? ""),
              ])
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.title ?? "",
              type: "metadata",
              list: .init(label: "Metadatas", url: "/admin/system/metadatas")
        )
    }
}
