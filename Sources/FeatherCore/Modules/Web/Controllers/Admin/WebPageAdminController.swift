//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

struct WebPageAdminController: AdminController {
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
            "date",
            "title",
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
            .init("date"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: Self.detailLink(model.title, id: model.uuid)),
            .init(model.metadataDetails.date.description),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
            .init(label: "Content", value: model.content),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
