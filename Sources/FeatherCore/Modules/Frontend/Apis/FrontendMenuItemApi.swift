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
        model.label = input.label
        model.url = input.url
        model.icon = input.icon
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.label = input.label
        model.url = input.url
        model.icon = input.icon
        model.isBlank = input.isBlank
        model.priority = input.priority
        model.permission = input.permission
        model.$menu.id = input.menuId
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.label = input.label ?? model.label
        model.url = input.url ?? model.url
        model.icon = input.icon ?? model.icon
        model.isBlank = input.isBlank ?? model.isBlank
        model.priority = input.priority ?? model.priority
        model.permission = input.permission ?? model.permission
        model.$menu.id = input.menuId ?? model.$menu.id
        return req.eventLoop.future()
    }

    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("label", optional: optional),
            KeyedContentValidator<String>.required("url", optional: optional),
            KeyedContentValidator<UUID>.required("menuId", optional: optional),
        ]
    }
}

