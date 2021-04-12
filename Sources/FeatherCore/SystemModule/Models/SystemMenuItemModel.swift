//
//  MenuModel.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuItemModel: FeatherModel {
    typealias Module = SystemModule

    static let name = "menuItems"
    static let schema = "\(Module.name)_menu_\(name)"
    static var pathComponent: PathComponent { "items" }
    
    struct FieldKeys {
        static var icon: FieldKey { "icon" }
        static var label: FieldKey { "label" }
        static var url: FieldKey { "url" }
        static var priority: FieldKey { "priority" }
        static var isBlank: FieldKey { "is_blank" }
        static var permission: FieldKey { "permission" }
        static var menuId: FieldKey { "menu_id" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.icon) var icon: String?
    @Field(key: FieldKeys.label) var label: String
    @Field(key: FieldKeys.url) var url: String
    @Field(key: FieldKeys.priority) var priority: Int
    @Field(key: FieldKeys.isBlank) var isBlank: Bool
    @Field(key: FieldKeys.permission) var permission: String?
    @Parent(key: FieldKeys.menuId) var menu: SystemMenuModel

    init() { }
    
    init(id: IDValue? = nil,
         icon: String? = nil,
         label: String,
         url: String,
         priority: Int = 100,
         isBlank: Bool = false,
         permission: String? = nil,
         menuId: UUID)
    {
        self.id = id
        self.icon = icon
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.$menu.id = menuId
    }
}

// MARK: - view

extension SystemMenuItemModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "icon": icon,
            "label": label,
            "url": url,
            "priority": priority,
            "targetBlank": isBlank,
            "permission": permission,
        ])
    }
}

