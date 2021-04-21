//
//  UserPermissionModel.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

final class UserPermissionModel: FeatherModel {
    typealias Module = SystemModule
    
    static let modelKey: String = "permissions"
    static let name: FeatherModelName = "Permission"

    struct FieldKeys {
        static var namespace: FieldKey { "namespace" }
        static var context: FieldKey { "context" }
        static var action: FieldKey { "action" }
        static var name: FieldKey { "name" }
        static var notes: FieldKey { "notes" }
    }
    
    // MARK: - fields

    /// unique identifier of the model
    @ID() var id: UUID?
    /// name of the permission
    @Field(key: FieldKeys.namespace) var namespace: String
    @Field(key: FieldKeys.context) var context: String
    @Field(key: FieldKeys.action) var action: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.notes) var notes: String?
    
    /// permission relation
    @Siblings(through: UserRolePermissionModel.self, from: \.$permission, to: \.$role) var roles: [UserRoleModel]
    
    init() { }

    init(id: UUID? = nil,
         namespace: String,
         context: String,
         action: String,
         name: String,
         notes: String? = nil) {
        self.id = id
        self.namespace = namespace
        self.context = context
        self.action = action
        self.name = name
        self.notes = notes
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.namespace,
            FieldKeys.context,
            FieldKeys.action,
            FieldKeys.name,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<UserPermissionModel>] {
        [
            \.$namespace ~~ term,
            \.$action ~~ term,
            \.$context ~~ term,
            \.$name ~~ term,
            \.$notes ~~ term,
        ]
    }
}

extension UserPermissionModel {

    var key: String { [namespace, context, action].joined(separator: ".") }
    
    var aclObject: Permission {
        Permission(namespace: namespace, context: context, action: .init(identifier: action))
    }
}

extension UserPermissionModel {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: name)
    }
}

extension UserPermissionModel {
    
    static func uniqueBy(_ namespace: String, _ context: String, _ action: String, _ req: Request) -> EventLoopFuture<Bool> {
        var query = UserPermissionModel.query(on: req.db)
            .filter(\.$namespace == namespace)
            .filter(\.$context == context)
            .filter(\.$action == action)
        
        
        if let modelId = getIdParameter(req: req) {
            query = query.filter(\.$id != modelId)
        }
        return query.count().map { $0 == 0  }
    }
}
