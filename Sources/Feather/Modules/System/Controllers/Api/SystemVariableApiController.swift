//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor
import Fluent
import FeatherApi

extension FeatherVariable.List: Content {}
extension FeatherVariable.Detail: Content {}

struct SystemVariableApiController: ApiController {
    typealias ApiModel = FeatherVariable
    typealias DatabaseModel = SystemVariableModel

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [FeatherVariable.List] {
        models.map { model in .init(id: model.uuid, key: model.key, value: model.value) }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> FeatherVariable.Detail {
        .init(id: model.uuid, key: model.key, name: model.name, value: model.value, notes: model.notes)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherVariable.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherVariable.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherVariable.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }
    
    @AsyncValidatorBuilder
    func validators(optional: Bool) -> [AsyncValidator] {
        KeyedContentValidator<String>.required("key")
        KeyedContentValidator<String>.required("name")
        KeyedContentValidator<String>("key", "Key must be unique", optional: optional) { req, value in
            try await req.system.variable.repository.isUnique(\.$key == value, FeatherVariable.getIdParameter(req))
        }
    }
}
