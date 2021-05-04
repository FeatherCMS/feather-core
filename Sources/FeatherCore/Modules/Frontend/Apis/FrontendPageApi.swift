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

