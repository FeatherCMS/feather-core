//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension UserListObject: Content {}
extension UserGetObject: Content {}
extension UserCreateObject: Content {}
extension UserUpdateObject: Content {}
extension UserPatchObject: Content {}

struct SystemUserApi: FeatherApiRepresentable {
    typealias Model = SystemUserModel
    
    typealias ListObject = UserListObject
    typealias GetObject = UserGetObject
    typealias CreateObject = UserCreateObject
    typealias UpdateObject = UserUpdateObject
    typealias PatchObject = UserPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, email: model.email)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, email: model.email, root: model.root)
    }
    
    func mapCreate(model: Model, input: CreateObject) {
        model.email = input.email
        model.password = input.password
        model.root = input.root ?? false
    }
    
    func mapUpdate(model: Model, input: UpdateObject) {
        model.email = input.email
        model.password = input.password
        model.root = input.root ?? false
    }

    func mapPatch(model: Model, input: PatchObject) {
        model.email = input.email ?? model.email
        model.password = input.password ?? model.password
        model.root = input.root ?? model.root
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
