//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor

public protocol PatchController: ModelController {
    
    func patchAccess(_ req: Request) async throws -> Bool
    func beforePatch(_ req: Request, _ model: DatabaseModel) async throws
    func afterPatch(_ req: Request, _ model: DatabaseModel) async throws
}

public extension PatchController {
        
    func patchAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: ApiModel.permission(for: .patch))
    }

    func beforePatch(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
    
    func afterPatch(_ req: Request, _ model: DatabaseModel) async throws {
        
    }
}
