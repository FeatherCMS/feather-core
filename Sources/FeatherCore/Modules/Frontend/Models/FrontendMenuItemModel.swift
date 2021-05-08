//
//  MenuModel.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class FrontendMenuItemModel: FeatherModel {
    typealias Module = FrontendModule

    static let modelKey = "items"
    static let name: FeatherModelName = "Menu item"
    static let schema = "\(Module.moduleKey)_menu_\(modelKey)"
    
    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: Module.moduleKey, context: "menu_" + modelKey, action: action)
    }

    struct FieldKeys {
        static var icon: FieldKey { "icon" }
        static var label: FieldKey { "label" }
        static var url: FieldKey { "url" }
        static var priority: FieldKey { "priority" }
        static var isBlank: FieldKey { "is_blank" }
        static var permission: FieldKey { "permission" }
        static var notes: FieldKey { "notes" }
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
    @Field(key: FieldKeys.notes) var notes: String?
    @Parent(key: FieldKeys.menuId) var menu: FrontendMenuModel

    init() { }
    
    init(id: IDValue? = nil,
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
        self.label = label.🦅
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.notes = notes
        self.$menu.id = menuId
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.label,
            FieldKeys.url,
            FieldKeys.priority,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<FrontendMenuItemModel>] {
        [
            \.$label ~~ term,
            \.$url ~~ term,
        ]
    }
}

extension FrontendMenuItemModel {
    
    static func adminLink(menuId: UUID) -> Link {
        let url = (FrontendMenuModel.adminLink.url + "/" + menuId.uuidString + "/" + modelKey).safePath()
        return .init(label: name.plural, url: url)
    }
}
