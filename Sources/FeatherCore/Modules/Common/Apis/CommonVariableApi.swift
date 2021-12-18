//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

extension CommonVariable.List: Content {}
extension CommonVariable.Detail: Content {}
extension CommonVariable.Create: Content {}
extension CommonVariable.Update: Content {}
extension CommonVariable.Patch: Content {}

struct CommonVariableApi: FeatherApi {
    typealias Model = CommonVariableModel

    func mapList(_ req: Request, model: Model) async -> CommonVariable.List {
        .init(id: model.uuid, key: model.key, value: model.value)
    }
    
    func mapDetail(_ req: Request, model: Model) async -> CommonVariable.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, value: model.value, notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CommonVariable.Create) async {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: Model, input: CommonVariable.Update) async {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func mapPatch(_ req: Request, model: Model, input: CommonVariable.Patch) async {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
