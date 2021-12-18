//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import FeatherCore

extension BlogCategory.List: Content {}
extension BlogCategory.Detail: Content {}
extension BlogCategory.Create: Content {}
extension BlogCategory.Update: Content {}
extension BlogCategory.Patch: Content {}

struct BlogCategoryApi: FeatherApi {
    typealias Model = BlogCategoryModel

    func mapList(_ req: Request, model: Model) async throws -> BlogCategory.List {
        .init(id: model.uuid,
              title: model.title,
              imageKey: model.imageKey,
              color: model.color,
              priority: model.priority,
              metadata: model.metadataDetails)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> BlogCategory.Detail {
        let posts = try await model.$posts.query(on: req.db).joinPublicMetadata().all()
        let postList = try await posts.asyncMap { try await BlogPostApi().mapList(req, model: $0) }
        return .init(id: model.uuid,
              title: model.title,
              imageKey: model.imageKey,
              excerpt: model.excerpt,
              color: model.color,
              priority: model.priority,
              posts: postList,
              metadata: model.metadataDetails)
    }
    
    func mapCreate(_ req: Request, model: Model, input: BlogCategory.Create) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func mapUpdate(_ req: Request, model: Model, input: BlogCategory.Update) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func mapPatch(_ req: Request, model: Model, input: BlogCategory.Patch) async throws {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.color = input.color ?? model.color
        model.priority = input.priority ?? model.priority
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
    
    // MARK: - api
    
    func findDetailBy(path: String, _ req: Request) async throws -> BlogCategory.Detail? {
        let category = try await BlogCategoryModel.queryJoinVisibleMetadataFilterBy(path: path, on: req.db).first()
        guard let category = category else {
            return nil
        }
        return try await mapDetail(req, model: category)
    }
    
}
