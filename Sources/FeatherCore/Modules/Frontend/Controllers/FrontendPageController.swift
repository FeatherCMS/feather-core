//
//  FrontendPageAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct FrontendPageController: FeatherController {
    
    typealias Module = FrontendModule
    typealias Model = FrontendPageModel
    
    typealias CreateForm = FrontendPageEditForm
    typealias UpdateForm = FrontendPageEditForm
    
    typealias GetApi = FrontendPageApi
    typealias ListApi = FrontendPageApi
    typealias CreateApi = FrontendPageApi
    typealias UpdateApi = FrontendPageApi
    typealias PatchApi = FrontendPageApi
    typealias DeleteApi = FrontendPageApi
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.title)])
        })
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
            .init(label: "Content", value: model.content),
        ]
    }
    
    func deleteContext(req: Request, model: FrontendPageModel) -> String {
        model.title
    }
}
