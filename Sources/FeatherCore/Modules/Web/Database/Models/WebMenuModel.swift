//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

final class WebMenuModel: FeatherDatabaseModel {
    typealias Module = WebModule
    
    struct FieldKeys {
        struct v1 {
            static var key: FieldKey { "key" }
            static var name: FieldKey { "name" }
            static var notes: FieldKey { "notes" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.key) var key: String
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.notes) var notes: String?
    @Children(for: \.$menu) var items: [WebMenuItemModel]

    init() { }

    init(id: UUID? = nil,
         key: String,
         name: String,
         notes: String? = nil)
    {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
    }
}

extension WebMenuModel {
    
    
    static func findWithItemsBy(id: UUID, on db: Database) async throws -> WebMenuModel {
        guard
            let model = try await WebMenuModel.query(on: db).filter(\.$id == id).with(\.$items).first()
        else {
            throw Abort(.notFound)
        }
        return model
    }
    
}
