//
//  FrontendPageModel.swift
//  FrontendModule
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

final class SystemPageModel: FeatherModel {
    typealias Module = SystemModule

    static let idKey: String = "pages"
    static let name: FeatherModelName = "Page"

    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var content: FieldKey { "content" }
        
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.content) var content: String

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         content: String)
    {
        self.id = id
        self.title = title
        self.content = content
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.title,
        ]
    }
    
    static func defaultSort() -> FieldSort {
        .asc
    }
    
    static func search(_ term: String) -> [ModelValueFilter<SystemPageModel>] {
        [
            \.$title ~~ term,
        ]
    }
}

// MARK: - metadata

extension SystemPageModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: title.slugify(), title: title)
    }
}
