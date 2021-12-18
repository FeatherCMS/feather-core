//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import Fluent

final class WebMenuItemModel: FeatherModel {
    typealias Module = WebModule

    static var modelKey: FeatherModelName = .init(singular: "menu_item")
    static var pathComponent: PathComponent = "items"
    
    struct FieldKeys {
        struct v1 {
            static var icon: FieldKey { "icon" }
            static var label: FieldKey { "label" }
            static var url: FieldKey { "url" }
            static var priority: FieldKey { "priority" }
            static var isBlank: FieldKey { "is_blank" }
            static var permission: FieldKey { "permission" }
            static var notes: FieldKey { "notes" }
            static var menuId: FieldKey { "menu_id" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.icon) var icon: String?
    @Field(key: FieldKeys.v1.label) var label: String
    @Field(key: FieldKeys.v1.url) var url: String
    @Field(key: FieldKeys.v1.priority) var priority: Int
    @Field(key: FieldKeys.v1.isBlank) var isBlank: Bool
    @Field(key: FieldKeys.v1.permission) var permission: String?
    @Field(key: FieldKeys.v1.notes) var notes: String?
    @Parent(key: FieldKeys.v1.menuId) var menu: WebMenuModel

    init() { }

    init(id: UUID? = nil,
         icon: String? = nil,
         label: String,
         url: String,
         priority: Int = 100,
         isBlank: Bool = false,
         permission: String? = nil,
         notes: String? = nil,
         menuId: UUID)
    {
        self.id = id
        self.icon = icon
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.notes = notes
        self.$menu.id = menuId
    }
}
