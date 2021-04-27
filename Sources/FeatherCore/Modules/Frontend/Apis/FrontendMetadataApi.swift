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
    
    func mapCreate(model: Model, input: CreateObject) {
        
    }
    
    func mapUpdate(model: Model, input: UpdateObject) {
        
    }

    func mapPatch(model: Model, input: PatchObject) {
        
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
}
