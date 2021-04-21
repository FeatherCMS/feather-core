//
//  FrontendPageAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct SystemPageController: FeatherController {
    
    typealias Module = SystemModule
    typealias Model = SystemPageModel
    
    typealias CreateForm = SystemPageEditForm
    typealias UpdateForm = SystemPageEditForm
    
    typealias GetApi = SystemVariableApi
    typealias ListApi = SystemVariableApi
    typealias CreateApi = SystemVariableApi
    typealias UpdateApi = SystemVariableApi
    typealias PatchApi = SystemVariableApi
    typealias DeleteApi = SystemVariableApi
    
    
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
    
    func deleteContext(req: Request, model: SystemPageModel) -> String {
        model.title
    }
}
