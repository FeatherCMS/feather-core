//
//  MenuModel.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

final class SystemMenuModel: FeatherModel {
    typealias Module = SystemModule

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

// MARK: - view

extension SystemMenuModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "key": key,
            "name": name,
            "notes": notes,
            "items": $items.value != nil ? items.sorted(by: { $0.priority > $1.priority }) : [],
        ])
    }
}

