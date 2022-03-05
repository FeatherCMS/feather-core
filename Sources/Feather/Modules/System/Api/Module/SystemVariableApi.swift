//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

public struct SystemVariableApi {

    private let repository: SystemVariableRepository
    
    init(_ repository: SystemVariableRepository) {
        self.repository = repository
    }
}

public extension SystemVariableApi {

    func list() async throws -> [FeatherApi.System.Variable.List] {
        try await repository.list().transform(to: [FeatherApi.System.Variable.List].self)
    }
    
    func list(_ ids: [UUID]) async throws -> [FeatherApi.System.Variable.List] {
        try await repository.get(ids).transform(to: [FeatherApi.System.Variable.List].self)
    }
    
    func get(_ id: UUID) async throws -> FeatherApi.System.Variable.Detail? {
        try await repository.get(id).transform(to: FeatherApi.System.Variable.Detail.self)
    }

    func get(_ ids: [UUID]) async throws -> [FeatherApi.System.Variable.Detail] {
        try await repository.get(ids).transform(to: [FeatherApi.System.Variable.Detail].self)
    }
    
    func find(_ key: String) async throws -> FeatherApi.System.Variable.Detail? {
        try await repository.find(key).transform(to: FeatherApi.System.Variable.Detail.self)
    }

}
