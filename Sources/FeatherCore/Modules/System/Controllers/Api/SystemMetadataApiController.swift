//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor
import Fluent
import FeatherObjects

extension FeatherMetadata.List: Content {}
extension FeatherMetadata.Detail: Content {}

struct SystemMetadataApiController: ApiListController, ApiDetailController, ApiUpdateController, ApiPatchController {
    
    typealias ApiModel = FeatherMetadata
    typealias DatabaseModel = SystemMetadataModel
    
    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [FeatherMetadata.List] {
        models.map { model in
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
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> FeatherMetadata.Detail {
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
        
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherMetadata.Update) async throws {
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
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: FeatherMetadata.Patch) async throws {
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

    func updateValidators() -> [AsyncValidator] {
        validators(optional: false)
    }
    
    func patchValidators() -> [AsyncValidator] {
        validators(optional: true)
    }
    
    @AsyncValidatorBuilder
    func validators(optional: Bool) -> [AsyncValidator] {
        KeyedContentValidator<String>("slug", "Slug must be unique", optional: optional) { req, value in
            try await req.system.metadata.repository.isUnique(\.$slug == value, FeatherMetadata.getIdParameter(req))
        }
    }
    
    func updateResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response {
        try await detailOutput(req, model).encodeResponse(for: req)
    }

    func patchResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response {
        try await detailOutput(req, model).encodeResponse(for: req)
    }
}
