//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Foundation
import FeatherApi

public struct SystemMetadataApi {

    let repository: SystemMetadataRepository
    
    init(_ repository: SystemMetadataRepository) {
        self.repository = repository
    }
}

public extension SystemMetadataApi {

    func list() async throws -> [FeatherMetadata.List] {
        try await repository.list().transform(to: [FeatherMetadata.List].self)
    }
    
    func listFeedItems() async throws -> [FeatherMetadata.List] {
        try await repository.listFeedItems().transform(to: [FeatherMetadata.List].self)
    }
    
    func list(_ ids: [UUID]) async throws -> [FeatherMetadata.List] {
        try await repository.get(ids).transform(to: [FeatherMetadata.List].self)
    }
    
    func get(_ id: UUID) async throws -> FeatherMetadata.Detail? {
        try await repository.get(id).transform(to: FeatherMetadata.Detail.self)
    }

    func get(_ ids: [UUID]) async throws -> [FeatherMetadata.Detail] {
        try await repository.get(ids).transform(to: [FeatherMetadata.Detail].self)
    }
}
