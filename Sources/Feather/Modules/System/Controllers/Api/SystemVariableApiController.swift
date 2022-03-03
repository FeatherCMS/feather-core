//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

extension System.Variable.List: Content {}
extension System.Variable.Detail: Content {}

struct SystemVariableApiController: ApiController {
    typealias ApiModel = System.Variable
    typealias DatabaseModel = SystemVariableModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [System.Variable.List] {
        models.map { model in .init(id: model.uuid, key: model.key, value: model.value) }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> System.Variable.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, value: model.value, notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: System.Variable.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: System.Variable.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: System.Variable.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
