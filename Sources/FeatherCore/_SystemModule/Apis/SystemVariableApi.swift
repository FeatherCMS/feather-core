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

struct SystemVariableApi: FeatherApiRepresentable {
    typealias Model = SystemVariableModel
    
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
    
    func mapCreate(model: Model, input: CreateObject) {
        model.key = input.key
        model.name = input.name
        model.value = input.value
        model.notes = input.notes
    }
    
    func mapUpdate(model: Model, input: UpdateObject) {
        model.key = input.key
        model.name = input.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }

    func mapPatch(model: Model, input: PatchObject) {
        model.key = input.key ?? model.key
        model.name = input.name ?? model.name
        model.value = input.value ?? model.value
        model.notes = input.notes ?? model.notes
    }

    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("key", as: String.self, is: !.empty && .count(...250))
//        validations.add("name", as: String.self, is: !.empty && .count(...250))

        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("key", as: String.self, is: !.empty && .count(...250))
//        validations.add("name", as: String.self, is: !.empty && .count(...250))

        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
//        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
//        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)

        req.eventLoop.future(true)
    }
}
