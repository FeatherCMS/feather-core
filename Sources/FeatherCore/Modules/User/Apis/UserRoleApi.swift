//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension RoleListObject: Content {}
extension RoleGetObject: Content {}
extension RoleCreateObject: Content {}
extension RoleUpdateObject: Content {}
extension RolePatchObject: Content {}

struct UserRoleApi: FeatherApiRepresentable {
    typealias Model = UserRoleModel
    
    typealias ListObject = RoleListObject
    typealias GetObject = RoleGetObject
    typealias CreateObject = RoleCreateObject
    typealias UpdateObject = RoleUpdateObject
    typealias PatchObject = RolePatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, name: model.name)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              key: model.key,
              name: model.name,
              notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.key = input.key
        model.name = input.name
        model.notes = input.notes
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedContentValidator<String>.required("key", optional: optional),
            KeyedContentValidator<String>("key", "Key must be unique", optional: optional, nil) { value, req in
                Model.isUniqueBy(\.$key == value, req: req)
            }
        ]
    }
}
