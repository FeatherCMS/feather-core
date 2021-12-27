//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

extension Web.Menu.List: Content {}
extension Web.Menu.Detail: Content {}

struct WebMenuApi: ApiController {
    typealias ApiModel = Web.MenuItem
    typealias DatabaseModel = WebMenuModel

    func listOutput(_ req: Request, _ model: DatabaseModel) async throws -> Web.Menu.List {
        .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes)
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Web.Menu.Detail {
        let api = WebMenuItemApi()
        let items = try await model.items.mapAsync { try await api.listOutput(req, $0) }
        return .init(id: model.uuid, key: model.key, name: model.name, notes: model.notes, items: items)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Menu.Create) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Menu.Update) async throws {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Menu.Patch) async throws {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedContentValidator<String>.required("key", optional: optional),
            KeyedContentValidator<String>("key", "Key must be unique", optional: optional) { value, req in
                try await DatabaseModel.isUnique(req, \.$key == value, Web.Menu.getIdParameter(req))
            }
        ]
    }
}
