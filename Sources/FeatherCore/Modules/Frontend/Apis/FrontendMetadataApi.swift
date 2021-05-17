//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 27..
//

extension MetadataListObject: Content {}
extension MetadataGetObject: Content {}
extension MetadataCreateObject: Content {}
extension MetadataUpdateObject: Content {}
extension MetadataPatchObject: Content {}

struct FrontendMetadataApi: FeatherApiRepresentable {
    typealias Model = FrontendMetadataModel
    
    typealias ListObject = MetadataListObject
    typealias GetObject = MetadataGetObject
    typealias CreateObject = MetadataCreateObject
    typealias UpdateObject = MetadataUpdateObject
    typealias PatchObject = MetadataPatchObject
    
    func mapList(model: Model) -> ListObject {    
        .init(id: model.id!,
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
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
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
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        fatalError("Standalone metadata should never be ceated.")
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
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
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
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
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>("slug", "Slug must be unique", optional: optional, nil) { value, req in
                guard Model.getIdParameter(req: req) == nil else {
                    return req.eventLoop.future(true)
                }
                return Model.isUniqueBy(\.$slug == value, req: req)
            }
        ]
    }
}
