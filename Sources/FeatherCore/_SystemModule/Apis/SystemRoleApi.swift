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

struct SystemRoleApi: FeatherApiRepresentable {
    typealias Model = SystemRoleModel
    
    typealias ListObject = RoleListObject
    typealias GetObject = RoleGetObject
    typealias CreateObject = RoleCreateObject
    typealias UpdateObject = RoleUpdateObject
    typealias PatchObject = RolePatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, name: model.name)
    }
}


// MARK: - api

extension SystemRoleModel {

    var getContent: RoleGetObject {
        .init(id: id!, key: key, name: name, notes: notes)
    }

    func create(_ input: RoleCreateObject) throws {
        key = input.key
        name = input.name
        notes = input.notes
    }

    func update(_ input: RoleUpdateObject) throws {
        key = input.key
        name = input.name
        notes = input.notes
    }

    func patch(_ input: RolePatchObject) throws {
        key = input.key ?? key
        name = input.name ?? name
        notes = input.notes ?? notes
    }
}


// MARK: - api validation



extension RoleCreateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension RoleUpdateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension RolePatchObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

