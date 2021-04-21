//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct FrontendMenuController: FeatherController {

    typealias Module = SystemModule
    typealias Model = FrontendMenuModel

    typealias CreateForm = FrontendMenuEditForm
    typealias UpdateForm = FrontendMenuEditForm
    
    typealias GetApi = FrontendMenuApi
    typealias ListApi = FrontendMenuApi
    typealias CreateApi = FrontendMenuApi
    typealias UpdateApi = FrontendMenuApi
    typealias PatchApi = FrontendMenuApi
    typealias DeleteApi = FrontendMenuApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name", "key"],
              rows: models.map { model in
                TableRow(id: model.identifier, cells: [TableCell(model.name), TableCell(model.key)])
              },
              action: TableRowAction(label: "Items",
                                     icon: "system",
                                     url: "/items/",
                                     permission: FrontendMenuItemModel.permission(for: .list).identifier))
    }
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }

    func beforeDelete(req: Request, model: FrontendMenuModel) -> EventLoopFuture<FrontendMenuModel> {
        FrontendMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
    }

    
    func detailFields(req: Request, model: FrontendMenuModel) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Key", value: model.key),
            .init(label: "Name", value: model.name),
            .init(label: "Notes", value: model.notes ?? ""),
        ]
    }
   
    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [
            .init(label: "Menu items", url: "/admin/system/menus/" + model.identifier + "/items/")
        ])
    }
    
    func deleteContext(req: Request, model: FrontendMenuModel) -> String {
        model.name
    }

}
