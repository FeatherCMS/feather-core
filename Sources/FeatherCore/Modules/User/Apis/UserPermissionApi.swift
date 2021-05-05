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
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.namespace = input.namespace
        model.context = input.context
        model.action = input.action
        model.name = input.name
        model.notes = input.notes
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.namespace = input.namespace ?? model.namespace
        model.context = input.context ?? model.context
        model.action = input.action ?? model.action
        model.name = input.name ?? model.name
        model.notes = input.notes ?? model.notes
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("namespace", optional: optional),
            KeyedContentValidator<String>.required("context", optional: optional),
            KeyedContentValidator<String>.required("action", optional: optional),
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedRequestValidator(key: "permission", message: "Permission must be unique") { req in
                struct InputPermission: Decodable {
                    var namespace: String
                    var context: String
                    var action: String
                }
                /// patch requires quite a different approach...
                if optional, let modelId = Model.getIdParameter(req: req) {
                    return Model.find(modelId, on: req.db).unwrap(or: Abort(.notFound)).map {
                        InputPermission(namespace: $0.namespace, context: $0.context, action: $0.action)
                    }
                    .map { perm -> InputPermission in
                        var newPerm = perm
                        if let value = try? req.content.get(String.self, at: "namespace") {
                            newPerm.namespace = value
                        }
                        if let value = try? req.content.get(String.self, at: "context") {
                            newPerm.context = value
                        }
                        if let value = try? req.content.get(String.self, at: "action") {
                            newPerm.action = value
                        }
                        return newPerm
                    }
                    .flatMap {
                        return Model.uniqueBy($0.namespace, $0.context, $0.action, req).map { isUnique in
                            guard isUnique else {
                                return false
                            }
                            return true
                        }
                    }
                }
                let p = try! req.content.decode(InputPermission.self)
                return Model.uniqueBy(p.namespace, p.context, p.action, req).map { isUnique in
                    guard isUnique else {
                        return false
                    }
                    return true
                }
            },
        ]
    }
    
    
}
