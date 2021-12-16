//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMenuItemController: AdminController {
    typealias Model = WebMenuItemModel
    
    typealias CreateModelEditor = WebMenuItemEditor
    typealias UpdateModelEditor = WebMenuItemEditor
    
    typealias ListModelApi = WebMenuItemApi
    typealias DetailModelApi = WebMenuItemApi
    typealias CreateModelApi = WebMenuItemApi
    typealias UpdateModelApi = WebMenuItemApi
    typealias PatchModelApi = WebMenuItemApi
    typealias DeleteModelApi = WebMenuItemApi
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
//            Model.FieldKeys.v1.key,
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
//            \.$key ~~ term,

        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.label.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.label, link: detailLink(model.label, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.label
    }
}
