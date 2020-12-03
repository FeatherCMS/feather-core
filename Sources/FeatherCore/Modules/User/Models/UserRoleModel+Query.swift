//
//  UserRoleModel+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

extension UserRoleModel {
    
    /// find role with permissions
    static func findWithPermissionsBy(id: UUID, on db: Database) -> EventLoopFuture<UserRoleModel?> {
        UserRoleModel.query(on: db).filter(\.$id == id).with(\.$permissions).first()
    }
}

