//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

public protocol FeatherModelRepository {
    var req: Request { get }

    associatedtype DatabaseModel: FeatherDatabaseModel    
}

public extension FeatherModelRepository where DatabaseModel.IDValue == UUID {

    func query() -> QueryBuilder<DatabaseModel> {
        DatabaseModel.query(on: req.db)
    }
    
    func query(_ id: UUID) -> QueryBuilder<DatabaseModel> {
        query().filter(\DatabaseModel._$id == id)
    }
    
    func query(_ ids: [UUID]) -> QueryBuilder<DatabaseModel> {
        query().filter(\DatabaseModel._$id ~~ ids)
    }

    func list() async throws -> [DatabaseModel] {
        try await query().all()
    }
    
    func get(_ ids: [UUID]) async throws -> [DatabaseModel] {
        try await query(ids).all()
    }

    func get(_ id: UUID) async throws -> DatabaseModel? {
        try await get([id]).first
    }

    func create(_ model: DatabaseModel) async throws -> DatabaseModel {
        try await model.create(on: req.db)
        return model
    }
    
    func update(_ model: DatabaseModel) async throws -> DatabaseModel {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ ids: [UUID]) async throws {
        try await query(ids).delete()
    }

    func delete(_ id: UUID) async throws {
        try await delete([id])
    }
    
    func isUnique(_ filter: ModelValueFilter<DatabaseModel>, _ id: UUID? = nil) async throws -> Bool {
        var query = query().filter(filter)
        if let id = id {
            query = query.filter(\DatabaseModel._$id != id)
        }
        let count = try await query.count()
        return count == 0
    }
}
