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
     
    
    func findBy(_ id: UUID, on db: Database) async throws -> Model {
        try await Model.findWithCategoriesAndAuthorsBy(id: id, on: db)
    }

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "date",
            "title"
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<Model>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("image"),
            .init("title"),
            .init("date"),
        ]
    }
    
    func listCells(for model: Model) -> [CellContext] {
        [
            .init(model.imageKey, link: LinkContext(label: model.title, permission: Self.detailPermission()), type: .image),
            .init(model.title, link: LinkContext(label: model.title, permission: Self.detailPermission())),
            .init(model.metadataDetails.date.description),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init("image", model.imageKey, type: .image),
            .init("id", model.identifier),
            .init("title", model.title),
            .init("categories", model.categories.map(\.title).joined(separator: "\n")),
            .init("authors", model.authors.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
