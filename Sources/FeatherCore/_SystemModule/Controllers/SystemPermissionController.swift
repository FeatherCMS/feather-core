//
//  UserPermissionAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct SystemPermissionController: FeatherController {

    typealias Module = SystemModule
    typealias Model = SystemPermissionModel
    typealias CreateForm = SystemPermissionEditForm
    typealias UpdateForm = SystemPermissionEditForm
    
    typealias GetApi = SystemVariableApi
    typealias ListApi = SystemVariableApi
    typealias CreateApi = SystemVariableApi
    typealias UpdateApi = SystemVariableApi
    typealias PatchApi = SystemVariableApi
    typealias DeleteApi = SystemVariableApi
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.name)])
        })
    }
    
    func getContext(req: Request, model: Model) -> GetViewContext {
        .init(title: "Permissions",
              key: "system.permissions",
              list: .init(label: "Permissions", url: "/admin/system/permissions/"),
              nav: [],
              fields: [
                .init(label: "Id", value: model.identifier),
                .init(label: "Key", value: model.key),
                .init(label: "Name", value: model.name),
                .init(label: "Namespace", value: model.namespace),
                .init(label: "Context", value: model.context),
                .init(label: "Action", value: model.action),
                .init(label: "Notes", value: model.notes ?? ""),
              ])
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "permission",
              list: .init(label: "Permissions", url: "/admin/system/permissoins")
        )
    }
}

