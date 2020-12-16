//
//  UserPermissionModel.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserPermissionModel: ViperModel {
    typealias Module = UserModule
    
    static let name = "permissions"

    struct FieldKeys {
        static var module: FieldKey { "module" }
        static var context: FieldKey { "context" }
        static var action: FieldKey { "action" }
        static var name: FieldKey { "name" }
        static var notes: FieldKey { "notes" }
    }
    
    // MARK: - fields

    /// unique identifier of the model
    @ID() var id: UUID?
    /// name of the permission
    @Field(key: FieldKeys.module) var module: String
    @Field(key: FieldKeys.context) var context: String
    @Field(key: FieldKeys.action) var action: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.notes) var notes: String?
    
    /// permission relation
    @Siblings(through: UserRolePermissionModel.self, from: \.$permission, to: \.$role) var roles: [UserRoleModel]
    
    init() { }

    init(id: UUID? = nil,
         module: String,
         context: String,
         action: String,
         name: String,
         notes: String? = nil) {
        self.id = id
        self.module = module
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }
}

extension UserPermissionModel {
    var key: String { [module, context, action].joined(separator: ".") }
}
