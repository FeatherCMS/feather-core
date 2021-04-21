//
//  MenuModel.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuModel: FeatherModel {
    typealias Module = SystemModule

    static let idKey: String = "menus"
    static let name: FeatherModelName = "Menu"
    
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
    @Children(for: \.$menu) var items: [SystemMenuItemModel]
    
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

    // MARK: - query
    
    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.key,
            FieldKeys.name,
        ]
    }

    static func search(_ term: String) -> [ModelValueFilter<SystemMenuModel>] {
        [
            \.$key ~~ term,
            \.$name ~~ term,
        ]
    }
}
