//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Foundation
import FeatherObjects

public struct SystemVariableApi {

    let repository: SystemVariableRepository
    
    init(_ repository: SystemVariableRepository) {
        self.repository = repository
    }
}

public extension SystemVariableApi {

    func list() async throws -> [FeatherVariable.List] {
        try await repository.list().transform(to: [FeatherVariable.List].self)
    }
    
    func list(_ ids: [UUID]) async throws -> [FeatherVariable.List] {
        try await repository.get(ids).transform(to: [FeatherVariable.List].self)
    }
    
    func get(_ id: UUID) async throws -> FeatherVariable.Detail? {
        try await repository.get(id).transform(to: FeatherVariable.Detail.self)
    }

    func get(_ ids: [UUID]) async throws -> [FeatherVariable.Detail] {
        try await repository.get(ids).transform(to: [FeatherVariable.Detail].self)
    }
    
    func find(_ key: String) async throws -> FeatherVariable.Detail? {
        try await repository.find(key).transform(to: FeatherVariable.Detail.self)
    }

}
