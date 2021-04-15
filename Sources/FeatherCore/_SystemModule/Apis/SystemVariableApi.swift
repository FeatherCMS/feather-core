//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 15..
//

struct SystemVariableApi: GetApiRepresentable, ListApiRepresentable, CreateApiRepresentable, UpdateApiRepresentable, PatchApiRepresentable, DeleteApiRepresentable {
    typealias Model = SystemVariableModel
    
    typealias GetObject = String
    typealias ListObject = String
    typealias CreateObject = String
    typealias UpdateObject = String
    typealias PatchObject = String
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

extension VariableCreateObject: Content {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariableUpdateObject: Content {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariablePatchObject: Content {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}
