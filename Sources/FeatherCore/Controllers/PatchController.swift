//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent

public protocol PatchController: ModelController {
    associatedtype PatchModelApi: PatchApi & DetailApi

    static func patchPermission() -> UserPermission
    static func patchPermission() -> String
    static func hasPatchPermission(_ req: Request) -> Bool
    
    func patchAccess(_ req: Request) async throws -> Bool
    func patchApi(_ req: Request) async throws -> PatchModelApi.DetailObject
}

public extension PatchController {
    
    static func patchPermission() -> UserPermission {
        Model.permission(.patch)
    }
    
    static func patchPermission() -> String {
        patchPermission().key
    }
    
    static func hasPatchPermission(_ req: Request) -> Bool {
        req.checkPermission(patchPermission())
    }
    
    func patchAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: Self.patchPermission())
    }

    func patchApi(_ req: Request) async throws -> PatchModelApi.DetailObject {
        let hasAccess = try await patchAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = PatchModelApi()
        try await RequestValidator(api.patchValidators()).validate(req)
        let model = try await findBy(identifier(req), on: req.db) as! PatchModelApi.Model
        let input = try req.content.decode(PatchModelApi.PatchObject.self)
        try await api.mapPatch(req, model: model, input: input)
        try await model.update(on: req.db)
        return try await api.mapDetail(req, model: model)
    }
}
