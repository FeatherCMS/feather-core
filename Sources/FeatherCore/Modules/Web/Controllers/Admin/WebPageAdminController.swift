//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

struct WebPageAdminController: AdminController {
    typealias ApiModel = Web.Page
    typealias DatabaseModel = WebPageModel
    
    typealias CreateModelEditor = WebPageEditor
    typealias UpdateModelEditor = WebPageEditor
    
    // MARK: - list
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "date",
            "title",
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
            .init("date"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.title, link: LinkContext(label: model.title, permission: ApiModel.permission(for: .detail).key)),
            .init(Feather.dateFormatter().string(from: model.featherMetadata.date)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [FieldContext] {
        [
            .init("id", model.uuid.string),
            .init("title", model.title),
            .init("content", model.content),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.title
    }
    
    func afterDelete(_ req: Request, _ model: DatabaseModel) async throws {
        if let key = model.featherMetadata.imageKey {
            try await req.fs.delete(key: key)
        }
    }
}
