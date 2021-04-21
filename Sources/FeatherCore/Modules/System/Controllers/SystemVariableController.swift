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
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Key", value: model.key),
            .init(label: "Name", value: model.name),
            .init(label: "Value", value: model.value ?? ""),
            .init(label: "Notes", value: model.notes ?? ""),
        ]
    }
    
    func deleteContext(req: Request, model: SystemVariableModel) -> String {
        model.name
    }    
}
