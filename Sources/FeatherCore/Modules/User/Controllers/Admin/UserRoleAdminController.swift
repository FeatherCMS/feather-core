//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct UserRoleAdminController: AdminController {
    typealias Model = UserRoleModel
    
    typealias CreateModelEditor = UserRoleEditor
    typealias UpdateModelEditor = UserRoleEditor
    
    typealias ListModelApi = UserRoleApi
    typealias DetailModelApi = UserRoleApi
    typealias CreateModelApi = UserRoleApi
    typealias UpdateModelApi = UserRoleApi
    typealias PatchModelApi = UserRoleApi
    typealias DeleteModelApi = UserRoleApi

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.name,
        ],
        defaultSort: .asc)
    }

    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.name.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.name, link: Self.detailLink(model.name, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Email", value: model.name),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
    
}
