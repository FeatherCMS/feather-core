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
        model.root = input.root
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.email = input.email
        model.password = input.password
        model.root = input.root
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.email = input.email ?? model.email
        model.password = input.password ?? model.password
        model.root = input.root ?? model.root
        return req.eventLoop.future()
    }

    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("email", optional: optional),
            KeyedContentValidator<String>.required("password", optional: optional),
            KeyedContentValidator<String>("email", "Email must be unique", optional: optional, nil) { value, req in
                Model.isUniqueBy(\.$email == value, req: req)
            }
        ]
    }
}
