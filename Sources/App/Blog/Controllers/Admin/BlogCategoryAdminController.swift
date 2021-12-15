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
    
    // MARK: - list

 
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            Model.FieldKeys.v1.title,
        ], defaultSort: .asc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init(Model.FieldKeys.v1.title.description, isDefault: true),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.title, link: detailLink(model.title, id: model.uuid)),
        ]
    }
    
    // MARK: - detail
    
    func detailContext(_ req: Request, _ model: Model) -> AdminDetailPageContext {
        .init(title: "Variable details", fields: [
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
        ])
    }

    // MARK: - delete
    
    func deleteContext(_ req: Request, _ model: Model, _ form: DeleteForm) -> AdminDeletePageContext {
        .init(title: "", name: model.title, type: "category", form: form.context(req))
    }
}
