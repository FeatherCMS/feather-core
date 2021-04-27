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

struct FrontendMenuApi: FeatherApiRepresentable {
    typealias Model = FrontendMenuModel
    
    typealias ListObject = MenuListObject
    typealias GetObject = MenuGetObject
    typealias CreateObject = MenuCreateObject
    typealias UpdateObject = MenuUpdateObject
    typealias PatchObject = MenuPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, key: model.key, name: model.name)
    }
    
    func mapGet(model: Model) -> GetObject {
        let itemsApi = FrontendMenuItemApi()
        return .init(id: model.id!,
              key: model.key,
              name: model.name,
              notes: model.notes,
              items: model.items.map { itemsApi.mapList(model: $0) })
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
