//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Vapor
import Fluent

struct SystemVariableRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemVariableModel

    public private(set) var db: Database
    
    init(_ db: Database) {
        self.db = db
    }
}

extension SystemVariableRepository {

    func find(_ key: String) async throws -> DatabaseModel? {
        try await query().filter(\.$key == key).first()
    }
}
