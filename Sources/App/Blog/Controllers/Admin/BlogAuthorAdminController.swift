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
            .init(label: "Name", value: model.name),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.name
    }
}
