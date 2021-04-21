//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension MenuListObject: Content {}
extension MenuGetObject: Content {}
extension MenuCreateObject: Content {}
extension MenuUpdateObject: Content {}
extension MenuPatchObject: Content {}

struct SystemMenuApi: FeatherApiRepresentable {
    typealias Model = SystemMenuModel
    
    typealias ListObject = MenuListObject
    typealias GetObject = MenuGetObject
    typealias CreateObject = MenuCreateObject
    typealias UpdateObject = MenuUpdateObject
    typealias PatchObject = MenuPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, key: model.key, name: model.name)
    }
    
    func mapGet(model: Model) -> GetObject {
        let itemsApi = SystemMenuItemApi()
        return .init(id: model.id!,
              key: model.key,
              name: model.name,
              notes: model.notes,
              items: model.items.map { itemsApi.mapList(model: $0) })
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
