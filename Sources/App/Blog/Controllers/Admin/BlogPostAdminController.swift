//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Fluent
import FeatherCore

struct BlogPostAdminController: AdminController {
    
    typealias Model = BlogPostModel
    
    typealias CreateModelEditor = BlogPostEditor
    typealias UpdateModelEditor = BlogPostEditor
    
    typealias ListModelApi = BlogPostApi
    typealias DetailModelApi = BlogPostApi
    typealias CreateModelApi = BlogPostApi
    typealias UpdateModelApi = BlogPostApi
    typealias PatchModelApi = BlogPostApi
    typealias DeleteModelApi = BlogPostApi
     
    
    func findBy(_ id: UUID, on db: Database) async throws -> BlogPostModel {
        guard let post = try await Model.findWithCategoriesAndAuthorsBy(id: id, on: db) else {
            throw Abort(.notFound)
        }
        return post
    }

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
            .init(label: "Title", value: model.title),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
