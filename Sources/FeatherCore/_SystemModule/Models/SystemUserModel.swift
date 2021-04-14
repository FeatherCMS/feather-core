//
//  UserModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class SystemUserModel: FeatherModel {
    typealias Module = SystemModule
    
    static let name = "users"

    struct FieldKeys {
        
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
        static var root: FieldKey { "root" }
    }
    
    // MARK: - fields
    
    /// unique identifier of the model
    @ID() var id: UUID?
    /// email address of the user
    @Field(key: FieldKeys.email) var email: String
    /// hashed password of the user
    @Field(key: FieldKeys.password) var password: String
    /// is the user root user
    @Field(key: FieldKeys.root) var root: Bool

    @Siblings(through: FeatherUserRoleModel.self, from: \.$user, to: \.$role) var roles: [SystemRoleModel]
    
    var permissions: [String] = []

    init() { }
    
    init(id: UUID? = nil,
         email: String,
         password: String,
         root: Bool = false)
    {
        self.id = id
        self.email = email
        self.password = password
        self.root = root
    }
    
    // MARK: - query
       
    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.email,
        ]
    }
    
    static func defaultSort() -> FieldSort {
        .asc
    }

    static func search(_ term: String) -> [ModelValueFilter<SystemUserModel>] {
        [
            \.$email ~~ term,
        ]
    }
}

// MARK: - auth

/// users can be authenticated using the session storage
extension SystemUserModel: SessionAuthenticatable {
    typealias SessionID = UUID

    var sessionID: SessionID { id! }
}



// MARK: - view

extension SystemUserModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "email": email,
            "root": root,
            "roles": $roles.value != nil ? roles.map(\.templateData) : [],
        ])
    }
}

extension SystemUserModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: id!.uuidString, label: email)
    }
}


// MARK: - api

extension SystemUserModel: ApiContentRepresentable {

    var listContent: UserListObject {
        .init(id: id!, email: email)
    }

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

extension UserListObject: Content {}
extension UserGetObject: Content {}
extension UserCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty && .count(8...250))
    }
}

extension UserUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty && .count(8...250))
    }
}

extension UserPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email, required: false)
        validations.add("password", as: String.self, is: !.empty && .count(8...250), required: false)
    }
}


// MARK: - helpers

extension SystemUserModel {

    /// find user by identifier with roles
    static func findWithRolesBy(id: UUID, on db: Database) -> EventLoopFuture<SystemUserModel?> {
        SystemUserModel.query(on: db).filter(\.$id == id).with(\.$roles).first()
    }
    
    /// find user by identifier with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<SystemUserModel?> {
        SystemUserModel.query(on: db)
            .filter(\.$id == id)
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
            .map { user in
                if user != nil {
                    user!.permissions = user!.roles.reduce([]) { $0 + $1.permissions.map(\.key) }
                }
                return user
            }
    }

    /// find user email with permissions
    static func findWithPermissionsBy(email: String, on db: Database) -> EventLoopFuture<SystemUserModel?> {
        SystemUserModel.query(on: db)
            .filter(\.$email == email.lowercased())
            .with(\.$roles) { role in role.with(\.$permissions) }
            .first()
            .map { user in
                if user != nil {
                    user!.permissions = user!.roles.reduce([]) { $0 + $1.permissions.map(\.key) }
                }
                return user
            }
    }
}


