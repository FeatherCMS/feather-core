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

    func mapList(model: Model) -> BlogCategory.List {
        .init(id: model.uuid,
              title: model.title,
              imageKey: model.imageKey,
              color: model.color,
              priority: model.priority)
    }
    
    func mapDetail(model: Model) -> BlogCategory.Detail {
        .init(id: model.uuid,
              title: model.title,
              imageKey: model.imageKey,
              excerpt: model.excerpt,
              color: model.color,
              priority: model.priority)
    }
    
    func mapCreate(_ req: Request, model: Model, input: BlogCategory.Create) async {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func mapUpdate(_ req: Request, model: Model, input: BlogCategory.Update) async {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func mapPatch(_ req: Request, model: Model, input: BlogCategory.Patch) async {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.color = input.color ?? model.color
        model.priority = input.priority ?? model.priority
    }
}
