//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension AccountListObject: Content {}
extension AccountGetObject: Content {}
extension AccountCreateObject: Content {}
extension AccountUpdateObject: Content {}
extension AccountPatchObject: Content {}

struct UserAccountApi: FeatherApiRepresentable {
    typealias Model = UserAccountModel
    
    typealias ListObject = AccountListObject
    typealias GetObject = AccountGetObject
    typealias CreateObject = AccountCreateObject
    typealias UpdateObject = AccountUpdateObject
    typealias PatchObject = AccountPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, email: model.email)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, email: model.email, root: model.root)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.email = input.email
        model.password = input.password
        model.root = input.root ?? false
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.email = input.email
        model.password = input.password
        model.root = input.root ?? false
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.email = input.email ?? model.email
        model.password = input.password ?? model.password
        model.root = input.root ?? model.root
        return req.eventLoop.future()
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("email", as: String.self, is: .email)
//        validations.add("password", as: String.self, is: !.empty && .count(8...250))
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("email", as: String.self, is: .email)
//        validations.add("password", as: String.self, is: !.empty && .count(8...250))
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("email", as: String.self, is: .email, required: false)
//        validations.add("password", as: String.self, is: !.empty && .count(8...250), required: false)
        req.eventLoop.future(true)
    }
}
