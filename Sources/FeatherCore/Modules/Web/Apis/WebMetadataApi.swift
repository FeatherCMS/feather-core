//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor

extension WebMetadata.List: Content {}
extension WebMetadata.Detail: Content {}
extension WebMetadata.Create: Content {}
extension WebMetadata.Update: Content {}
extension WebMetadata.Patch: Content {}

struct WebMetadataApi: FeatherApi {
    typealias Model = WebMetadataModel
    
    func mapList(_ req: Request, model: Model) async throws -> WebMetadata.List {
        mapList(model: model)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> WebMetadata.Detail {
        mapDetail(model: model)
    }
    
    func mapCreate(_ req: Request, model: Model, input: WebMetadata.Create) async throws {
        mapCreate(model: model, input: input)
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebMetadata.Update) async throws {
        mapUpdate(model: model, input: input)
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebMetadata.Patch) async throws {
        mapPatch(model: model, input: input)
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
    
    // MARK: - internal helpers
    
    func mapList(model: Model) -> WebMetadata.List {
        .init(id: model.uuid,
              module: model.module,
              model: model.model,
              reference: model.reference,
              slug: model.slug,
              title: model.title,
              excerpt: model.excerpt,
              imageKey: model.imageKey,
              date: model.date,
              status: .init(rawValue: model.status.rawValue)!,
              feedItem: model.feedItem,
              canonicalUrl: model.canonicalUrl,
              filters: model.filters,
              css: model.css,
              js: model.js)
    }
    
    func mapDetail(model: Model) -> WebMetadata.Detail {
        .init(id: model.uuid,
              module: model.module,
              model: model.model,
              reference: model.reference,
              slug: model.slug,
              title: model.title,
              excerpt: model.excerpt,
              imageKey: model.imageKey,
              date: model.date,
              status: .init(rawValue: model.status.rawValue)!,
              feedItem: model.feedItem,
              canonicalUrl: model.canonicalUrl,
              filters: model.filters,
              css: model.css,
              js: model.js)
    }
    
    func mapCreate(model: Model, input: WebMetadata.Create) {
        model.slug = input.slug
        model.title = input.title
        model.excerpt = input.excerpt
        model.imageKey = input.imageKey
        model.date = input.date
        model.status = .init(rawValue: input.status.rawValue)!
        model.feedItem = input.feedItem
        model.canonicalUrl = input.canonicalUrl
        model.css = input.css
        model.js = input.js
    }

    func mapUpdate(model: Model, input: WebMetadata.Update) {
        model.slug = input.slug
        model.title = input.title
        model.excerpt = input.excerpt
        model.imageKey = input.imageKey
        model.date = input.date
        model.status = .init(rawValue: input.status.rawValue)!
        model.feedItem = input.feedItem
        model.canonicalUrl = input.canonicalUrl
        model.css = input.css
        model.js = input.js
    }
    
    func mapPatch(model: Model, input: WebMetadata.Patch) {
        model.slug = input.slug ?? model.slug
        model.title = input.title ?? model.title
        model.excerpt = input.excerpt ?? model.excerpt
        model.imageKey = input.imageKey ?? model.imageKey
        model.date = input.date ?? model.date
        if let status = input.status?.rawValue {
            model.status = .init(rawValue: status) ?? model.status
        }
        model.feedItem = input.feedItem ?? model.feedItem
        model.canonicalUrl = input.canonicalUrl ?? model.canonicalUrl
        model.css = input.css ?? model.css
        model.js = input.js ?? model.js
    }
}
