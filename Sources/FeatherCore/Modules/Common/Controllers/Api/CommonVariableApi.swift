//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

extension Common.Variable.List: Content {}
extension Common.Variable.Detail: Content {}

struct CommonVariableApiController: ApiController {
    typealias ApiModel = Common.Variable
    typealias DatabaseModel = CommonVariableModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Common.Variable.List] {
        models.map { model in .init(id: model.uuid, key: model.key, value: model.value) }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Common.Variable.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, value: model.value, notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Common.Variable.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Common.Variable.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Common.Variable.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
