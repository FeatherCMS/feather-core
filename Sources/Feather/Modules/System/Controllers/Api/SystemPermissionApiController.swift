//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

extension FeatherPermission.List: Content {}
extension FeatherPermission.Detail: Content {}

struct SystemPermissionApiController: ApiController {
    typealias ApiModel = FeatherPermission
    typealias DatabaseModel = SystemPermissionModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [FeatherPermission.List] {
        models.map { model in
                .init(id: model.uuid,
                      namespace: model.namespace,
                      context: model.context,
                      action: model.action,
                      name: model.name)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> FeatherPermission.Detail {
        .init(id: model.uuid,
              namespace: model.namespace,
              context: model.context,
              action: model.action,
              name: model.name,
              notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherPermission.Create) async throws {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherPermission.Update) async throws {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherPermission.Patch) async throws {
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
