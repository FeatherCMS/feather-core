//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 17..
//

import FeatherTest
@testable import FeatherCore

extension MetadataGetObject: UUIDContent {}

final class FrontendMetadataApiTests: FeatherApiTestCase {
    
    override func modelName() -> String {
        "Metadata"
    }
    
    override func endpoint() -> String {
        "frontend/metadatas"
    }
    
    func testListMetadatas() throws {
        try list(MetadataListObject.self)
    }
}

