//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension UserPermission.List: Content {}
extension UserPermission.Detail: Content {}
extension UserPermission.Create: Content {}
extension UserPermission.Update: Content {}
extension UserPermission.Patch: Content {}

struct UserPermissionApi: FeatherApi {
    typealias Model = UserPermissionModel
    
    func mapList(_ req: Request, model: Model) async -> UserPermission.List {
        .init(id: model.uuid, name: model.name)
    }
    
    func mapDetail(_ req: Request, model: Model) async -> UserPermission.Detail {
        .init(id: model.uuid,
              namespace: model.namespace,
              context: model.context,
              action: model.action,
              name: model.name,
              notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: UserPermission.Create) async {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UserPermission.Update) async {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapPatch(_ req: Request, model: Model, input: UserPermission.Patch) async {
        model.namespace = input.namespace ?? model.namespace
        model.context = input.context ?? model.context
        model.action = input.action ?? model.action
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
}
