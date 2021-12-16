//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct UserPermissionAdminController: AdminController {
    typealias Model = UserPermissionModel
    
    typealias CreateModelEditor = UserPermissionEditor
    typealias UpdateModelEditor = UserPermissionEditor
    
    typealias ListModelApi = UserPermissionApi
    typealias DetailModelApi = UserPermissionApi
    typealias CreateModelApi = UserPermissionApi
    typealias UpdateModelApi = UserPermissionApi
    typealias PatchModelApi = UserPermissionApi
    typealias DeleteModelApi = UserPermissionApi

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.name,
        ])
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
