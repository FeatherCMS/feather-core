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
    
    func mapCreate(model: Model, input: CreateObject) {
        
    }
    
    func mapUpdate(model: Model, input: UpdateObject) {
        
    }

    func mapPatch(model: Model, input: PatchObject) {
        
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
}

