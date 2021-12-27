//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

extension User.Permission.List: Content {}
extension User.Permission.Detail: Content {}

struct UserPermissionApi: ApiController {
    typealias ApiModel = User.Permission
    typealias DatabaseModel = UserPermissionModel
    
    func listOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Permission.List {
        .init(id: model.uuid, name: model.name)
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Permission.Detail {
        .init(id: model.uuid,
              namespace: model.namespace,
              context: model.context,
              action: model.action,
              name: model.name,
              notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: User.Permission.Create) async throws {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: User.Permission.Update) async throws {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: User.Permission.Patch) async throws {
        model.namespace = input.namespace ?? model.namespace
        model.context = input.context ?? model.context
        model.action = input.action ?? model.action
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
