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

    func patchAccess(_ req: Request) async -> Bool
    func patchApi(_ req: Request) async throws -> PatchModelApi.DetailObject
}

public extension PatchController {
    
    func patchAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Model.permission(.patch))
    }

    func patchApi(_ req: Request) async throws -> PatchModelApi.DetailObject {
        let hasAccess = await patchAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = PatchModelApi()
        try await RequestValidator(api.patchValidators()).validate(req)
        let model = try await findBy(identifier(req), on: req.db) as! PatchModelApi.Model
        let input = try req.content.decode(PatchModelApi.PatchObject.self)
        await api.mapPatch(req, model: model, input: input)
        try await model.update(on: req.db)
        return api.mapDetail(model: model)
    }
}
