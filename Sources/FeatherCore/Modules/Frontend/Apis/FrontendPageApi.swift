//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension PageListObject: Content {}
extension PageGetObject: Content {}
extension PageCreateObject: Content {}
extension PageUpdateObject: Content {}
extension PagePatchObject: Content {}

struct FrontendPageApi: FeatherApiRepresentable {
    typealias Model = FrontendPageModel

    typealias ListObject = PageListObject
    typealias GetObject = PageGetObject
    typealias CreateObject = PageCreateObject
    typealias UpdateObject = PageUpdateObject
    typealias PatchObject = PagePatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, title: model.title)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, title: model.title, content: model.content)
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

