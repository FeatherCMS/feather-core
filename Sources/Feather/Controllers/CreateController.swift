//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor

public protocol CreateController: ModelController {    
    func createAccess(_ req: Request) async throws -> Bool
    func beforeCreate(_ req: Request, _ model: DatabaseModel) async throws
    func afterCreate(_ req: Request, _ model: DatabaseModel) async throws
}

public extension CreateController {


    func createAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: ApiModel.permission(for: .create))
    }
    
    func beforeCreate(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
    
    func afterCreate(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
    
    
}

