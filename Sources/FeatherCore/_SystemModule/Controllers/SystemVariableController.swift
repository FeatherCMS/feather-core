//
//  SystemVariableAdminController.swift
//  SystemModule
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//
//
struct SystemVariableController: FeatherController {
    

    typealias Module = SystemModule
    typealias Model = SystemVariableModel
    
    typealias CreateForm = SystemVariableEditForm
    typealias UpdateForm = SystemVariableEditForm
    
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
        .init(title: "Variable",
              key: "system.variables",
              list: .init(label: "Variables", url: "/admin/system/variables/"),
              nav: [],
              fields: [
                .init(label: "Id", value: model.identifier),
                .init(label: "Key", value: model.key),
                .init(label: "Name", value: model.name),
                .init(label: "Value", value: model.value ?? ""),
                .init(label: "Notes", value: model.notes ?? ""),
              ])
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "variable",
              list: .init(label: "Variables", url: "/admin/system/variables")
        )
    }
    
}
