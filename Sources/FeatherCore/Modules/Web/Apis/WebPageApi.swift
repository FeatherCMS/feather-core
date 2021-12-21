//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import Fluent

extension WebPage.List: Content {}
extension WebPage.Detail: Content {}
extension WebPage.Create: Content {}
extension WebPage.Update: Content {}
extension WebPage.Patch: Content {}

struct WebPageApi: FeatherApi {
    typealias Model = WebPageModel

    func mapList(_ req: Request, model: Model) async throws -> WebPage.List {
        .init(id: model.uuid, title: model.title, metadata: model.metadataDetails)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> WebPage.Detail {
        .init(id: model.uuid, title: model.title, content: model.content)
    }
    
    func mapCreate(_ req: Request, model: Model, input: WebPage.Create) async throws {
        model.title = input.title
        model.content = input.content
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebPage.Update) async throws {
        model.title = input.title
        model.content = input.content
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebPage.Patch) async throws {
        model.title = input.title ?? model.title
        model.content = input.content ?? model.content
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
            KeyedContentValidator<String>("title", "Title must be unique", optional: optional) { value, req in
                guard Model.getIdParameter(req: req) == nil else {
                    return true
                }
                return try await Model.isUniqueBy(\.$title == value, req: req)
            }
        ]
    }
}
