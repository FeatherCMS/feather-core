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
}
