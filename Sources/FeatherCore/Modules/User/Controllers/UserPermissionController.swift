//
//  UserPermissionAdminController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

struct UserPermissionController: FeatherController {

    typealias Module = UserModule
    typealias Model = UserPermissionModel
    typealias CreateForm = UserPermissionEditForm
    typealias UpdateForm = UserPermissionEditForm
    
    typealias GetApi = UserPermissionApi
    typealias ListApi = UserPermissionApi
    typealias CreateApi = UserPermissionApi
    typealias UpdateApi = UserPermissionApi
    typealias PatchApi = UserPermissionApi
    typealias DeleteApi = UserPermissionApi
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.name)])
        })
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Key", value: model.key),
            .init(label: "Name", value: model.name),
            .init(label: "Namespace", value: model.namespace),
            .init(label: "Context", value: model.context),
            .init(label: "Action", value: model.action),
            .init(label: "Notes", value: model.notes ?? ""),
        ]
    }
    
    func deleteContext(req: Request, model: UserPermissionModel) -> String {
        model.name
    }
}

