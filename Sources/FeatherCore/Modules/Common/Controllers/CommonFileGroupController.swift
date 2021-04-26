//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 26..
//

struct CommonFileGroupController: FeatherController {

    typealias Module = CommonModule
    typealias Model = CommonFileGroupModel

    typealias CreateForm = CommonFileGroupEditForm
    typealias UpdateForm = CommonFileGroupEditForm
    
    typealias GetApi = FrontendMenuApi
    typealias ListApi = FrontendMenuApi
    typealias CreateApi = FrontendMenuApi
    typealias UpdateApi = FrontendMenuApi
    typealias PatchApi = FrontendMenuApi
    typealias DeleteApi = FrontendMenuApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title"],
              rows: models.map { model in
                TableRow(id: model.identifier, cells: [TableCell(model.title)])
              },
              action: TableRowAction(label: "Items",
                                     icon: "system",
                                     url: "/items/",
                                     permission: FrontendMenuItemModel.permission(for: .list).identifier))
    }
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }

//    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
//        FrontendMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
//    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
            
        ]
    }
   
    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [
//            .init(label: "Menu items", url: "/admin/system/menus/" + model.identifier + "/items/")
        ])
    }
    
    func deleteContext(req: Request, model: Model) -> String {
        model.title
    }

}
