//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

extension WebMenu.List: Content {}
extension WebMenu.Detail: Content {}
extension WebMenu.Create: Content {}
extension WebMenu.Update: Content {}
extension WebMenu.Patch: Content {}

struct WebMenuApi: FeatherApi {
    typealias Model = WebMenuModel

    func mapList(_ req: Request, model: Model) async throws -> WebMenu.List {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> WebMenu.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes, items: [])
    }
    
    func mapCreate(_ req: Request, model: Model, input: WebMenu.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebMenu.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebMenu.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedContentValidator<String>.required("key", optional: optional),
            KeyedContentValidator<String>("key", "Key must be unique", optional: optional) { value, req in
                try await Model.isUniqueBy(\.$key == value, req: req)
            }
        ]
    }
}
