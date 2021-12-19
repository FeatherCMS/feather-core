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
            "title"
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: LinkContext(label: model.title, permission: Self.detailPermission())),
            .init(model.metadataDetails.title, link: LinkContext(label: model.metadataDetails.title ?? "Details", permission: Self.detailPermission())),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("id", model.identifier),
            .init("title", model.title),
            .init("excerpt", model.excerpt),
            .init("color", model.color),
            .init("priority", String(model.priority)),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
