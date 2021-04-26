//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 25..
//


final class CommonFileModel: FeatherModel {
    typealias Module = CommonModule

    static let modelKey: String = "files"
    static let name: FeatherModelName = "File"

    
    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var name: FieldKey { "name" }
        static var type: FieldKey { "type" }
        static var size: FieldKey { "size" }

        static var tag: FieldKey { "tag" }
        static var width: FieldKey { "width" }
        static var height: FieldKey { "height" }
        
        static var groupId: FieldKey { "group_id" }
    }

    // MARK: - fields
    
    @ID() var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.type) var type: String
    @Field(key: FieldKeys.size) var size: Int
    
    @Field(key: FieldKeys.tag) var tag: String?
    @Field(key: FieldKeys.width) var width: Int?
    @Field(key: FieldKeys.height) var height: Int?

    @Parent(key: FieldKeys.groupId) var group: CommonFileGroupModel
        
    
    init() {}

    init(id: UUID? = nil,
         key: String,
         name: String,
         type: String,
         size: Int,
         tag: String? = nil,
         width: Int? = nil,
         height: Int? = nil)
    {
        self.id = id
        self.key = key
        self.name = name
        self.type = type
        self.size = size
        
        self.tag = tag
        self.width = width
        self.height = height
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.name,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<CommonFileModel>] {
        [
            \.$name ~~ term,
        ]
    }
}

