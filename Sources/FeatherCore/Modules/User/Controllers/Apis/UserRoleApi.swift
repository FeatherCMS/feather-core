//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

extension User.Role.List: Content {}
extension User.Role.Detail: Content {}

struct UserRoleApi: ApiController {
    typealias ApiModel = User.Role
    typealias DatabaseModel = UserRoleModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [User.Role.List] {
        models.map { model in .init(id: model.uuid, name: model.name) }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Role.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: User.Role.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: User.Role.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: User.Role.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
