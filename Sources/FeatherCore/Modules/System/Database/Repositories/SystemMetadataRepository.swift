//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor
import Fluent

struct SystemMetadataRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemMetadataModel

    public private(set) var db: Database
    
    init(_ db: Database) {
        self.db = db
    }
    
    func listFeedItems() async throws -> [DatabaseModel] {
        try await query().filter(\.$feedItem == true).all()
    }
}
