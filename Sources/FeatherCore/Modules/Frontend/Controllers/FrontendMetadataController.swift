//
//  FrontendContentAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct FrontendMetadataController: FeatherController {
    
    typealias Module = SystemModule
    typealias Model = FrontendMetadataModel
    
    typealias CreateForm = FrontendMetadataEditForm
    typealias UpdateForm = FrontendMetadataEditForm
    
    #warning("fixme")
    typealias GetApi = CommonVariableApi
    typealias ListApi = CommonVariableApi
    typealias CreateApi = CommonVariableApi
    typealias UpdateApi = CommonVariableApi
    typealias PatchApi = CommonVariableApi
    typealias DeleteApi = CommonVariableApi
    
//        "title": "Metadatas",
//        "key": "frontend.metadatas",
//        "create": false,
//        "delete": false,
//        "fields": [
//            ["key": "slug", "default": true, "placeholder": "home"]
//        ]
    
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title", "slug"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.title), TableCell(model.slug)])
        })
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }
    
    func detailFields(req: Request, model: FrontendMetadataModel) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(type: .image, label: "Image", value: model.imageKey ?? ""),
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
        ]
    }

    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [
            .init(label: "Preview", url: model.slug.safePath(), isBlank: true),
            .init(label: "Reference", url: "/admin/" + model.module + "/" + model.model + "/" + model.reference.uuidString + "/"),
        ])
    }
    
    func deleteContext(req: Request, model: FrontendMetadataModel) -> String {
        model.title ?? model.identifier
    }
}
