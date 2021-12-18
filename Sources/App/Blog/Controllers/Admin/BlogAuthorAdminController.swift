//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Fluent
import FeatherCore

struct BlogAuthorAdminController: AdminController {
    
    typealias Model = BlogAuthorModel
    
    typealias CreateModelEditor = BlogAuthorEditor
    typealias UpdateModelEditor = BlogAuthorEditor
    
    typealias ListModelApi = BlogAuthorApi
    typealias DetailModelApi = BlogAuthorApi
    typealias CreateModelApi = BlogAuthorApi
    typealias UpdateModelApi = BlogAuthorApi
    typealias PatchModelApi = BlogAuthorApi
    typealias DeleteModelApi = BlogAuthorApi
     
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "name"
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("name"),

        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.name, link: Self.detailLink(model.name, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("name", model.name),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
}
