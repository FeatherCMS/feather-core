//
//  MenuModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class FrontendMenuModel: ViperModel {
    typealias Module = FrontendModule

    static let name = "menus"
    
    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var name: FieldKey { "name" }
        static var notes: FieldKey { "notes" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.notes) var notes: String?
    @Children(for: \.$menu) var items: [FrontendMenuItemModel]
    
    init() { }
    
    init(id: IDValue? = nil,
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
