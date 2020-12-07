//
//  MenuModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class FrontendMenuItemModel: ViperModel {
    typealias Module = FrontendModule

    static let name = "items"
    
    struct FieldKeys {
        static var icon: FieldKey { "icon" }
        static var label: FieldKey { "label" }
        static var url: FieldKey { "url" }
        static var priority: FieldKey { "priority" }
        static var targetBlank: FieldKey { "target_blank" }
        static var permission: FieldKey { "permission" }
        static var menuId: FieldKey { "menu_id" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.icon) var icon: String?
    @Field(key: FieldKeys.label) var label: String
    @Field(key: FieldKeys.url) var url: String
    @Field(key: FieldKeys.priority) var priority: Int
    @Field(key: FieldKeys.targetBlank) var targetBlank: Bool
    @Field(key: FieldKeys.permission) var permission: String?
    @Parent(key: FieldKeys.menuId) var menu: FrontendMenuModel

    init() { }
    
    init(id: IDValue? = nil,
         icon: String? = nil,
         label: String,
         url: String,
         priority: Int = 100,
         targetBlank: Bool = false,
         permission: String? = nil,
         menuId: UUID)
    {
        self.id = id
        self.icon = icon
        self.label = label
        self.url = url
        self.priority = priority
        self.targetBlank = targetBlank
        self.permission = permission
        self.$menu.id = menuId
    }
}
