//
//  SystemVariableAdminController.swift
//  SystemModule
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

struct SystemVariableAdminController: AdminViewController {

    typealias Module = SystemModule
    typealias Model = SystemVariableModel
    typealias CreateForm = SystemVariableEditForm
    typealias UpdateForm = SystemVariableEditForm
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"], rows: models.map { model in
            TableRow(id: model.id!.uuidString, cells: [TableCell(model.name)])
        })
    }
    
    func deleteContext(req: Request, model: Model, formId: String, formToken: String) -> DeleteControllerContext {
        .init(id: formId,
              token: formToken,
              context: model.name,
              type: "variable",
              list: .init(title: "Variables", url: "/admin/system/variables")
        )
    }
    
}
