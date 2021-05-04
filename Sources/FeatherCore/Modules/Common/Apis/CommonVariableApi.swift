//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

extension VariableListObject: Content {}
extension VariableGetObject: Content {}
extension VariableCreateObject: Content {}
extension VariableUpdateObject: Content {}
extension VariablePatchObject: Content {}

struct CommonVariableApi: FeatherApiRepresentable {
    typealias Model = CommonVariableModel
    
    typealias ListObject = VariableListObject
    typealias GetObject = VariableGetObject
    typealias CreateObject = VariableCreateObject
    typealias UpdateObject = VariableUpdateObject
    typealias PatchObject = VariablePatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, key: model.key, value: model.value)
    }

    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, key: model.key, name: model.name, value: model.value, notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
        return req.eventLoop.future()
    }
    
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
        return req.eventLoop.future()
    }

    func validators(optional: Bool) -> [AsyncValidator] {
        [
            ContentValidator<String>.required(key: "name", optional: optional),
            ContentValidator<String>.required(key: "key", optional: optional),
            ContentValidator<String>(key: "key", message: "Key must be unique", optional: optional, validation: nil, asyncValidation: { value, req in
                Model.isUniqueBy(\.$key == value, req: req)
            })
        ]
    }
}
