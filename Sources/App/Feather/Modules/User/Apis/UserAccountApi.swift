//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

extension UserAccount.List: Content {}
extension UserAccount.Detail: Content {}
extension UserAccount.Create: Content {}
extension UserAccount.Update: Content {}
extension UserAccount.Patch: Content {}

struct UserAccountApi: FeatherApi {
    typealias Model = UserAccountModel
    
    func mapList(model: UserAccountModel) -> UserAccount.List {
        .init(id: model.uuid, email: model.email)
    }
    
    func mapDetail(model: UserAccountModel) -> UserAccount.Detail {
        .init(id: model.uuid, email: model.email, root: model.isRoot)
    }
    
    func mapCreate(_ req: Request, model: UserAccountModel, input: UserAccount.Create) async {
        model.email = input.email
        model.password = input.password
        model.isRoot = input.root
    }
    
    func mapUpdate(_ req: Request, model: UserAccountModel, input: UserAccount.Update) async {
        model.email = input.email
        model.password = input.password
        model.isRoot = input.root
    }
    
    func mapPatch(_ req: Request, model: UserAccountModel, input: UserAccount.Patch) async {
        model.email = input.email ?? model.email
        model.password = input.password ?? model.password
        model.isRoot = input.root ?? model.isRoot
    }
}