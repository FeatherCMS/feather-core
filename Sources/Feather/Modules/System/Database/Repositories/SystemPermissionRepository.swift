//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor
import Fluent
import FeatherApi

struct SystemPermissionRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemPermissionModel

    public private(set) var req: Request
    
    init(_ req: Request) {
        self.req = req
    }

    // MARK: - additional query methods

    func get(_ permission: FeatherPermission) async throws -> DatabaseModel? {
        try await DatabaseModel.query(on: req.db)
                .filter(\.$namespace == permission.namespace)
                .filter(\.$context == permission.context)
                .filter(\.$action == permission.action.key)
                .first()
    }
    
    func get(_ key: String) async throws -> DatabaseModel? {
        try await get(.init(key))
    }

    func isUnique(_ permission: FeatherPermission) async throws -> Bool {
        var query = SystemPermissionModel.query(on: req.db)
            .filter(\.$namespace == permission.namespace)
            .filter(\.$context == permission.context)
            .filter(\.$action == permission.action.key)

        if let modelId = FeatherPermission.getIdParameter(req) {
            query = query.filter(\.$id != modelId)
        }
        let count = try await query.count()
        return count == 0
    }
}
