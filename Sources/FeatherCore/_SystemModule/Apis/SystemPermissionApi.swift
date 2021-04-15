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

struct SystemPermissionApi: FeatherApiRepresentable {
    typealias Model = SystemPermissionModel
    
    typealias ListObject = PermissionListObject
    typealias GetObject = PermissionGetObject
    typealias CreateObject = PermissionCreateObject
    typealias UpdateObject = PermissionUpdateObject
    typealias PatchObject = PermissionPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, name: model.name)
    }
}


// MARK: - api

extension SystemPermissionModel {

    var getContent: PermissionGetObject {
        .init(id: id!, module: namespace, context: context, action: action, name: name, notes: notes)
    }

    func create(_ input: PermissionCreateObject) throws {
        namespace = input.module
        context = input.context
        action = input.action
        name = input.name
        notes = input.notes
    }

    func update(_ input: PermissionUpdateObject) throws {
        namespace = input.module
        context = input.context
        action = input.action
        name = input.name
        notes = input.notes
    }

    func patch(_ input: PermissionPatchObject) throws {
        namespace = input.module ?? namespace
        context = input.context ?? context
        action = input.action ?? action
        name = input.name ?? name
        notes = input.notes ?? notes
    }
}


// MARK: - api validation



extension PermissionCreateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250))
        validations.add("context", as: String.self, is: !.empty && .count(...250))
        validations.add("action", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension PermissionUpdateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250))
        validations.add("context", as: String.self, is: !.empty && .count(...250))
        validations.add("action", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension PermissionPatchObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("module", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("context", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("action", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

