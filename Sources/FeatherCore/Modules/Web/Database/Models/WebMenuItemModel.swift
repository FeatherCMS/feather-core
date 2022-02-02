//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

final class WebMenuItemModel: FeatherDatabaseModel {
    typealias Module = WebModule

    static var featherIdentifier: String = "menu_items"
    
    struct FieldKeys {
        struct v1 {
            static var label: FieldKey { "label" }
            static var url: FieldKey { "url" }
            static var priority: FieldKey { "priority" }
            static var isBlank: FieldKey { "is_blank" }
            static var permission: FieldKey { "permission" }
            static var menuId: FieldKey { "menu_id" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.label) var label: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Field(key: FieldKeys.v1.priority) var priority: Int
    @Field(key: FieldKeys.v1.isBlank) var isBlank: Bool
    @Field(key: FieldKeys.v1.permission) var permission: String?
    @Parent(key: FieldKeys.v1.menuId) var menu: WebMenuModel

    init() { }

    init(id: UUID? = nil,
         label: String,
         url: String,
         priority: Int = 100,
         isBlank: Bool = false,
         permission: String? = nil,
         menuId: UUID)
    {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.$menu.id = menuId
    }
}
