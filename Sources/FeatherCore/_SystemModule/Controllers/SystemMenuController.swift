//
//  MenuAdminController.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

struct SystemMenuController: FeatherController {

    typealias Module = SystemModule
    typealias Model = SystemMenuModel

    typealias CreateForm = SystemMenuEditForm
    typealias UpdateForm = SystemMenuEditForm
    
    typealias GetApi = SystemMenuApi
    typealias ListApi = SystemMenuApi
    typealias CreateApi = SystemMenuApi
    typealias UpdateApi = SystemMenuApi
    typealias PatchApi = SystemMenuApi
    typealias DeleteApi = SystemMenuApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name", "key"],
              rows: models.map { model in
                TableRow(id: model.identifier, cells: [TableCell(model.name), TableCell(model.key)])
              },
              action: TableRowAction(label: "Items",
                                     icon: "system",
                                     url: "/items/",
                                     permission: SystemMenuItemModel.permission(for: .list).identifier))
    }
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }

    func beforeDelete(req: Request, model: SystemMenuModel) -> EventLoopFuture<SystemMenuModel> {
        SystemMenuItemModel.query(on: req.db).filter(\.$menu.$id == model.id!).delete().map { model }
    }

    func getContext(req: Request, model: Model) -> GetViewContext {
        .init(title: "Menu",
              key: "system.menus",
              list: .init(label: "Menus", url: "/admin/system/menus/"),
              nav: [
                .init(label: "Menu items", url: "/admin/system/menus/" + model.identifier + "/items/")
              ],
              fields: [
                .init(label: "Id", value: model.identifier),
                .init(label: "Key", value: model.key),
                .init(label: "Name", value: model.name),
                .init(label: "Notes", value: model.notes ?? ""),
              ])
    }

    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "menu",
              list: .init(label: "Menus", url: "/admin/system/menus")
        )
    }
}
