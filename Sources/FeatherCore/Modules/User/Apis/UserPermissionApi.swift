//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension PermissionListObject: Content {}
extension PermissionGetObject: Content {}
extension PermissionCreateObject: Content {}
extension PermissionUpdateObject: Content {}
extension PermissionPatchObject: Content {}

struct UserPermissionApi: FeatherApiRepresentable {
    typealias Model = UserPermissionModel
    
    typealias ListObject = PermissionListObject
    typealias GetObject = PermissionGetObject
    typealias CreateObject = PermissionCreateObject
    typealias UpdateObject = PermissionUpdateObject
    typealias PatchObject = PermissionPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, name: model.name)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              namespace: model.namespace,
              context: model.context,
              action: model.action,
              name: model.name,
              notes: model.notes)
    }
    
    func mapCreate(model: Model, input: CreateObject) {
        model.namespace = input.module
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }
    
    func mapUpdate(model: Model, input: UpdateObject) {
        model.namespace = input.module
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
    }

    func mapPatch(model: Model, input: PatchObject) {
        model.namespace = input.module ?? model.namespace
        model.context = input.context ?? model.context
        model.action = input.action ?? model.action
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("module", as: String.self, is: !.empty && .count(...250))
//        validations.add("context", as: String.self, is: !.empty && .count(...250))
//        validations.add("action", as: String.self, is: !.empty && .count(...250))
//        validations.add("name", as: String.self, is: !.empty && .count(...250))
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("module", as: String.self, is: !.empty && .count(...250))
//        validations.add("context", as: String.self, is: !.empty && .count(...250))
//        validations.add("action", as: String.self, is: !.empty && .count(...250))
//        validations.add("name", as: String.self, is: !.empty && .count(...250))
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("module", as: String.self, is: !.empty && .count(...250), required: false)
//        validations.add("context", as: String.self, is: !.empty && .count(...250), required: false)
//        validations.add("action", as: String.self, is: !.empty && .count(...250), required: false)
//        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
        req.eventLoop.future(true)
    }
}
