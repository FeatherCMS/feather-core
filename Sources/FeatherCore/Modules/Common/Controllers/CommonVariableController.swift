//
//  SystemVariableAdminController.swift
//  SystemModule
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//
//
struct CommonVariableController: FeatherController {
    
    typealias Module = CommonModule
    typealias Model = CommonVariableModel
    
    typealias CreateForm = SystemVariableEditForm
    typealias UpdateForm = SystemVariableEditForm
    
    typealias GetApi = CommonVariableApi
    typealias ListApi = CommonVariableApi
    typealias CreateApi = CommonVariableApi
    typealias UpdateApi = CommonVariableApi
    typealias PatchApi = CommonVariableApi
    typealias DeleteApi = CommonVariableApi
    
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
    
    func deleteContext(req: Request, model: CommonVariableModel) -> String {
        model.name
    }    
}
