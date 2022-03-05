//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor

public protocol UpdateController: ModelController {

    func updateAccess(_ req: Request) async throws -> Bool
    func beforeUpdate(_ req: Request, _ model: DatabaseModel) async throws
    func afterUpdate(_ req: Request, _ model: DatabaseModel) async throws
    
}

public extension UpdateController {
    
    func updateAccess(_ req: Request) async throws-> Bool {
        try await req.checkAccess(for: ApiModel.permission(for: .update))
    }
    
    func beforeUpdate(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
    
    func afterUpdate(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
}
