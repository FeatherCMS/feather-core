//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import FeatherCore

extension BlogPost.List: Content {}
extension BlogPost.Detail: Content {}
extension BlogPost.Create: Content {}
extension BlogPost.Update: Content {}
extension BlogPost.Patch: Content {}

struct BlogPostApi: FeatherApi {
    typealias Model = BlogPostModel

    func mapList(_ req: Request, model: Model) async -> BlogPost.List {
        .init(id: model.uuid,
              title: model.title,
              imageKey: model.imageKey,
              excerpt: model.excerpt,
              metadata: model.metadataDetails)
    }
    
    func mapDetail(_ req: Request, model: Model) async -> BlogPost.Detail {
//        let categoryApi = BlogCategoryApi()
//        let authorApi = BlogAuthorApi()
        return .init(id: model.id!,
                     title: model.title,
                     imageKey: model.imageKey,
                     excerpt: model.excerpt,
                     content: model.content,
                     categories: [],//(model.$categories.value ?? []).map { categoryApi.mapList(model: $0) },
                     authors: [],
                     metadata: model.metadataDetails) //(model.$authors.value ?? []).map { authorApi.mapList(model: $0) })
    }
    
    func mapCreate(_ req: Request, model: Model, input: BlogPost.Create) async {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
    }
    
    func mapUpdate(_ req: Request, model: Model, input: BlogPost.Update) async {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
    }
    
    func mapPatch(_ req: Request, model: Model, input: BlogPost.Patch) async {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.content = input.content ?? model.content
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
    
//    func validators(optional: Bool) -> [AsyncValidator] {
//        [
//            KeyedContentValidator<String>.required("title", optional: optional),
//            KeyedContentValidator<String>("title", "Title must be unique", optional: optional, nil) { value, req in
//                Model.isUniqueBy(\.$title == value, req: req)
//            }
//        ]
//    }
}
