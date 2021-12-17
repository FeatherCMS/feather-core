//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import FeatherCore

extension BlogAuthor.List: Content {}
extension BlogAuthor.Detail: Content {}
extension BlogAuthor.Create: Content {}
extension BlogAuthor.Update: Content {}
extension BlogAuthor.Patch: Content {}

struct BlogAuthorApi: FeatherApi {
    typealias Model = BlogAuthorModel

    func mapList(_ req: Request, model: Model) async -> BlogAuthor.List {
        .init(id: model.uuid,
              name: model.name,
              imageKey: model.imageKey)
    }
    
    func mapDetail(_ req: Request, model: Model) async -> BlogAuthor.Detail {
//        let linkApi = BlogAuthorLinkApi()
        return .init(id: model.uuid,
              name: model.name,
              imageKey: model.imageKey,
              bio: model.bio,
              links: [])//(model.$links.value ?? []).map { linkApi.mapList(model: $0) })
    }
    
    func mapCreate(_ req: Request, model: Model, input: BlogAuthor.Create) async {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
    }
    
    func mapUpdate(_ req: Request, model: Model, input: BlogAuthor.Update) async {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
    }
    
    func mapPatch(_ req: Request, model: Model, input: BlogAuthor.Patch) async {
        model.name = input.name ?? model.name
        model.imageKey = input.imageKey ?? model.imageKey
        model.bio = input.bio ?? model.bio
    }
    
    
//    func validators(optional: Bool) -> [AsyncValidator] {
//        [
//            KeyedContentValidator<String>.required("name", optional: optional),
//            KeyedContentValidator<String>("name", "Name must be unique", optional: optional, nil) { value, req in
//                Model.isUniqueBy(\.$name == value, req: req)
//            }
//        ]
//    }
    
}
