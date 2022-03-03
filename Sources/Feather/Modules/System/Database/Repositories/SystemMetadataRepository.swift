//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import FeatherRestKit

struct SystemMetadataRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemMetadataModel

    public private(set) var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    func listFeedItems() async throws -> [DatabaseModel] {
        try await query().filter(\.$feedItem == true).all()
    }
}
