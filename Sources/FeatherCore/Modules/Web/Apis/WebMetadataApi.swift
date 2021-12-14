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
    
    func mapCreate(_ req: Request, model: Model, input: WebMetadata.Create) async {
        
    }
    
    func mapUpdate(_ req: Request, model: Model, input: WebMetadata.Update) async {
        
    }
    
    func mapPatch(_ req: Request, model: Model, input: WebMetadata.Patch) async {
        
    }
}
