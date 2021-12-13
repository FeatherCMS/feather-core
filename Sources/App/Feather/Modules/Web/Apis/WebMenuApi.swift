//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension WebMenu.List: Content {}
extension WebMenu.Detail: Content {}
extension WebMenu.Create: Content {}
extension WebMenu.Update: Content {}
extension WebMenu.Patch: Content {}

struct WebMenuApi: FeatherApi {
    typealias Model = WebMenuModel

    func mapList(model: Model) -> WebMenu.List {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes)
    }
    
    func mapDetail(model: WebMenuModel) -> WebMenu.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes, items: [])
    }
    
    func mapCreate(_ req: Request, model: WebMenuModel, input: WebMenu.Create) async {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: WebMenuModel, input: WebMenu.Update) async {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapPatch(_ req: Request, model: WebMenuModel, input: WebMenu.Patch) async {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
}