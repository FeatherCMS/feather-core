//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension MenuItemListObject: Content {}
extension MenuItemGetObject: Content {}
extension MenuItemCreateObject: Content {}
extension MenuItemUpdateObject: Content {}
extension MenuItemPatchObject: Content {}

struct SystemMenuItemApi: FeatherApiRepresentable {
    typealias Model = SystemMenuItemModel
    
    typealias ListObject = MenuItemListObject
    typealias GetObject = MenuItemGetObject
    typealias CreateObject = MenuItemCreateObject
    typealias UpdateObject = MenuItemUpdateObject
    typealias PatchObject = MenuItemPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, label: model.label, url: model.url, menuId: model.$menu.id)
    }
}

