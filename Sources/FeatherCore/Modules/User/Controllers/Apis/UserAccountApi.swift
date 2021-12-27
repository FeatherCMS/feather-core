//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

extension User.Account.List: Content {}
extension User.Account.Detail: Content {}


struct UserAccountApi: ApiController {
    typealias ApiModel = User.Account
    typealias DatabaseModel = UserAccountModel
    
    func listOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Account.List {
        .init(id: model.uuid, email: model.email)
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> User.Account.Detail {
        .init(id: model.uuid, email: model.email, isRoot: model.isRoot)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Create) async throws {
        model.email = input.email
        model.password = input.password
        model.isRoot = input.isRoot
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Update) async throws {
        model.email = input.email
        model.password = input.password
        model.isRoot = input.isRoot
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: User.Account.Patch) async throws {
        model.email = input.email ?? model.email
        model.password = input.password ?? model.password
        model.isRoot = input.isRoot ?? model.isRoot
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}

