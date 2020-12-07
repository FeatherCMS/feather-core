//
//  SystemVariableAdminController.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

struct SystemVariableAdminController: ViperAdminViewController {

    typealias Module = SystemModule
    typealias Model = SystemVariableModel
    typealias CreateForm = SystemVariableEditForm
    typealias UpdateForm = SystemVariableEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
        Model.FieldKeys.key,
        Model.FieldKeys.value,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<SystemVariableModel>, req: Request) {
        queryBuilder.filter(\.$name ~~ search)
        queryBuilder.filter(\.$key ~~ search)
        queryBuilder.filter(\.$value ~~ search)
    }
    
    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<SystemVariableModel>) -> QueryBuilder<SystemVariableModel> {
        queryBuilder.filter(\.$hidden == false)
    }
}
