//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension WebPage.List: Content {}
extension WebPage.Detail: Content {}
extension WebPage.Create: Content {}
extension WebPage.Update: Content {}
extension WebPage.Patch: Content {}

struct WebPageApi: FeatherApi {
    typealias Model = WebPageModel

    func mapList(_ req: Request, model: Model) async -> WebPage.List {
        .init(id: model.uuid, title: model.title)
    }
    
    func mapDetail(_ req: Request, model: Model) async -> WebPage.Detail {
        .init(id: model.uuid, title: model.title, content: model.content)
    }
    
    func mapCreate(_ req: Request, model: Model, input: WebPage.Create) async {
        model.title = input.title
        model.content = input.content
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebPage.Update) async {
        model.title = input.title
        model.content = input.content
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebPage.Patch) async {
        model.title = input.title ?? model.title
        model.content = input.content ?? model.content
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
