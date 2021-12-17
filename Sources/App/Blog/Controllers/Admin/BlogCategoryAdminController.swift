//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import FeatherCore

struct BlogCategoryAdminController: AdminController {
    
    typealias Model = BlogCategoryModel
    
    typealias CreateModelEditor = BlogCategoryEditor
    typealias UpdateModelEditor = BlogCategoryEditor
    
    typealias ListModelApi = BlogCategoryApi
    typealias DetailModelApi = BlogCategoryApi
    typealias CreateModelApi = BlogCategoryApi
    typealias UpdateModelApi = BlogCategoryApi
    typealias PatchModelApi = BlogCategoryApi
    typealias DeleteModelApi = BlogCategoryApi
    
    static var modelName: FeatherModelName = .init(singular: "category", plural: "categories")
 
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.title,
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.title.description, isDefault: true),
            .init(Model.FieldKeys.v1.title.description),

        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: Self.detailLink(model.title, id: model.uuid)),
            .init(model.metadataDetails.title, link: Self.detailLink(model.title, id: model.uuid)),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
            .init(label: "Excerpt", value: model.excerpt),
            .init(label: "Color", value: model.color),
            .init(label: "Priority", value: String(model.priority)),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
