//
//  UserModel+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

extension UserModel {

    /// find user by identifier with roles
    static func findWithRolesBy(id: UUID, on db: Database) -> EventLoopFuture<UserModel?> {
        UserModel.query(on: db).filter(\.$id == id).with(\.$roles).first()
    }
    
    /// find user by identifier with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<UserModel?> {
        UserModel.query(on: db)
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
    static func findWithPermissionsBy(email: String, on db: Database) -> EventLoopFuture<UserModel?> {
        UserModel.query(on: db)
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

