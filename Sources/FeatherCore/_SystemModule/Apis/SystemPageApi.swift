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

struct SystemPageApi: FeatherApiRepresentable {
    typealias Model = SystemPageModel

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
}

