//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebMenuItemAdminController: AdminController {
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
            "label",
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$label ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("label"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.label, link: Self.detailLink(model.label, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("label", model.label),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.label
    }
}
