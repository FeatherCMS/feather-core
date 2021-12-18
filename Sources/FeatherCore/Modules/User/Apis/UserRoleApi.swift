//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension UserRole.List: Content {}
extension UserRole.Detail: Content {}
extension UserRole.Create: Content {}
extension UserRole.Update: Content {}
extension UserRole.Patch: Content {}

struct UserRoleApi: FeatherApi {
    typealias Model = UserRoleModel
    
    func mapList(_ req: Request, model: Model) async throws -> UserRole.List {
        .init(id: model.uuid, name: model.name)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> UserRole.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: UserRole.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UserRole.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapPatch(_ req: Request, model: Model, input: UserRole.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
