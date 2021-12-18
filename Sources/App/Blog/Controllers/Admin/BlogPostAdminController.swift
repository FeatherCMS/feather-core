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
            .init(model.imageKey, link: Self.detailLink(model.title, id: model.uuid), type: .image),
            .init(model.title, link: Self.detailLink(model.title, id: model.uuid)),
            .init(model.metadataDetails.date.description),
        ]
    }
    
    func detailFields(for model: Model) -> [FieldContext] {
        [
            .init(label: "Image", value: model.imageKey, type: .image),
            .init(label: "Id", value: model.identifier),
            .init(label: "Title", value: model.title),
            .init(label: "Categories", value: model.categories.map(\.title).joined(separator: "\n")),
            .init(label: "Authors", value: model.authors.map(\.name).joined(separator: "\n")),
        ]
    }
    
    func deleteInfo(_ model: Model) -> String {
        model.title
    }
}
