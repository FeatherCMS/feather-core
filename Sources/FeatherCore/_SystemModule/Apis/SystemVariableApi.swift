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
}



// MARK: - api

extension SystemVariableModel {

    var listContent: VariableListObject {
        .init(id: id!, key: key, value: value)
    }

    var getContent: VariableGetObject {
        .init(id: id!, key: key, name: name, value: value, notes: notes)
    }

    func create(_ input: VariableCreateObject) throws {
        key = input.key
        name = input.name
        value = input.value
        notes = input.notes
    }

    func update(_ input: VariableUpdateObject) throws {
        key = input.key
        name = input.name
        value = input.value ?? value
        notes = input.notes ?? notes
    }

    func patch(_ input: VariablePatchObject) throws {
        key = input.key ?? key
        name = input.name ?? name
        value = input.value ?? value
        notes = input.notes ?? notes
    }
}

extension VariableCreateObject{

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariableUpdateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariablePatchObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}
