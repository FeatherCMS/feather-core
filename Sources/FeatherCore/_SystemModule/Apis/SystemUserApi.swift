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
}


// MARK: - api

extension SystemUserModel {

    var getContent: UserGetObject {
        .init(id: id!, email: email, root: root)
    }

    func create(_ input: UserCreateObject) throws {
        email = input.email
        password = input.password
        root = input.root ?? false
    }

    func update(_ input: UserUpdateObject) throws {
        email = input.email
        password = input.password
        root = input.root ?? false
    }

    func patch(_ input: UserPatchObject) throws {
        email = input.email ?? email
        password = input.password ?? password
        root = input.root ?? root
    }
}

// MARK: - api validation

extension UserCreateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty && .count(8...250))
    }
}

extension UserUpdateObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty && .count(8...250))
    }
}

extension UserPatchObject {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email, required: false)
        validations.add("password", as: String.self, is: !.empty && .count(8...250), required: false)
    }
}
