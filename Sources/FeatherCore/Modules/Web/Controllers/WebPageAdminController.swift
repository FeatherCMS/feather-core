//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebPageController: AdminController {
    typealias Model = WebPageModel
    
    typealias CreateModelEditor = WebPageEditor
    typealias UpdateModelEditor = WebPageEditor
    
    typealias ListModelApi = WebPageApi
    typealias DetailModelApi = WebPageApi
    typealias CreateModelApi = WebPageApi
    typealias UpdateModelApi = WebPageApi
    typealias PatchModelApi = WebPageApi
    typealias DeleteModelApi = WebPageApi
    
    // MARK: - list
    
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
            .init(Model.FieldKeys.v1.title.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: Self.detailLink(model.title, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
