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

struct FrontendMenuItemApi: FeatherApiRepresentable {
    typealias Model = FrontendMenuItemModel
    
    typealias ListObject = MenuItemListObject
    typealias GetObject = MenuItemGetObject
    typealias CreateObject = MenuItemCreateObject
    typealias UpdateObject = MenuItemUpdateObject
    typealias PatchObject = MenuItemPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, label: model.label, url: model.url, menuId: model.$menu.id)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              label: model.label,
              url: model.url,
              icon: model.icon,
              isBlank: model.isBlank,
              priority: model.priority,
              permission: model.permission,
              menuId: model.$menu.id)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] { [] }
}

