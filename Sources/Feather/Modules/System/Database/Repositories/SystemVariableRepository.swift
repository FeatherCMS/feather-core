//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 24..
//

import Fluent

struct SystemVariableRepository: FeatherModelRepository {
    typealias DatabaseModel = SystemVariableModel

    public private(set) var req: Request
    
    init(_ req: Request) {
        self.req = req
    }
}

extension SystemVariableRepository {

    func find(_ key: String) async throws -> DatabaseModel? {
        try await query().filter(\.$key == key).first()
    }
}
