//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor
import Fluent
import FeatherObjects

struct SystemPermissionRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemPermissionModel

    public private(set) var db: Database
    
    init(_ db: Database) {
        self.db = db
    }

    // MARK: - additional query methods

    func get(_ permission: FeatherPermission) async throws -> DatabaseModel? {
        try await DatabaseModel.query(on: db)
                .filter(\.$namespace == permission.namespace)
                .filter(\.$context == permission.context)
                .filter(\.$action == permission.action.key)
                .first()
    }
    
    func get(_ key: String) async throws -> DatabaseModel? {
        try await get(.init(key))
    }

    func isUnique(_ permission: FeatherPermission, id: UUID? = nil) async throws -> Bool {
        var query = SystemPermissionModel.query(on: db)
            .filter(\.$namespace == permission.namespace)
            .filter(\.$context == permission.context)
            .filter(\.$action == permission.action.key)

        if let modelId = id {
            query = query.filter(\.$id != modelId)
        }
        let count = try await query.count()
        return count == 0
    }
}
