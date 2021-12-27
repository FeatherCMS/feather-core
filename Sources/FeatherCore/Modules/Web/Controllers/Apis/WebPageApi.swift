//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

extension Web.Page.List: Content {}
extension Web.Page.Detail: Content {}

struct WebPageApi: ApiController {
    typealias ApiModel = Web.Page
    typealias DatabaseModel = WebPageModel

    func listOutput(_ req: Request, _ model: DatabaseModel) async throws -> Web.Page.List {
        .init(id: model.uuid, title: model.title, metadata: model.featherMetadata)
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Web.Page.Detail {
        let content = try await model.filter(model.content, req)
        return .init(id: model.uuid, title: model.title, content: content)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Page.Create) async throws {
        model.title = input.title
        model.content = input.content
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Page.Update) async throws {
        model.title = input.title
        model.content = input.content
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Web.Page.Patch) async throws {
        model.title = input.title ?? model.title
        model.content = input.content ?? model.content
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
            KeyedContentValidator<String>("title", "Title must be unique", optional: optional) { value, req in
                guard ApiModel.getIdParameter(req) == nil else {
                    return true
                }
                return try await DatabaseModel.isUnique(req, \.$title == value, Web.Page.getIdParameter(req))
            }
        ]
    }
}
