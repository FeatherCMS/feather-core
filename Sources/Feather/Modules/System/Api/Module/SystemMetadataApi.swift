//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

public struct SystemMetadataApi {

    let repository: SystemMetadataRepository
    
    init(_ repository: SystemMetadataRepository) {
        self.repository = repository
    }
}

public extension SystemMetadataApi {

    func list() async throws -> [FeatherApi.System.Metadata.List] {
        try await repository.list().transform(to: [FeatherApi.System.Metadata.List].self)
    }
    
    func listFeedItems() async throws -> [FeatherApi.System.Metadata.List] {
        try await repository.listFeedItems().transform(to: [FeatherApi.System.Metadata.List].self)
    }
    
    func list(_ ids: [UUID]) async throws -> [FeatherApi.System.Metadata.List] {
        try await repository.get(ids).transform(to: [FeatherApi.System.Metadata.List].self)
    }
    
    func get(_ id: UUID) async throws -> FeatherApi.System.Metadata.Detail? {
        try await repository.get(id).transform(to: FeatherApi.System.Metadata.Detail.self)
    }

    func get(_ ids: [UUID]) async throws -> [FeatherApi.System.Metadata.Detail] {
        try await repository.get(ids).transform(to: [FeatherApi.System.Metadata.Detail].self)
    }
}
