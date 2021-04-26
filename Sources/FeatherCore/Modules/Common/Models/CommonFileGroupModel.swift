//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 26..
//

final class CommonFileGroupModel: FeatherModel {
    typealias Module = CommonModule

    static let modelKey: String = "file_groups"
    static let name: FeatherModelName = "File group"

    struct FieldKeys {
        static var path: FieldKey { "path" }
        static var title: FieldKey { "title" }
        static var excerpt: FieldKey { "excerpt" }
        static var notes: FieldKey { "notes" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.path) var path: String
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.excerpt) var excerpt: String?
    @Field(key: FieldKeys.notes) var notes: String?
    @Children(for: \.$group) var files: [CommonFileModel]
    
    init() {}

    init(id: UUID? = nil,
         path: String,
         title: String,
         excerpt: String? = nil,
         notes: String? = nil)
    {
        self.id = id
        self.path = path
        self.title = title
        self.excerpt = excerpt
        self.notes = notes
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.title,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<CommonFileGroupModel>] {
        [
            \.$title ~~ term,
        ]
    }
}

