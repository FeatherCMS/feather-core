//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public protocol ApiPatchController: PatchController {
    associatedtype PatchObject: Decodable
    
    func patchValidators() -> [AsyncValidator]
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: PatchObject) async throws
    func patchApi(_ req: Request) async throws -> Response
    func patchResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response
    func setUpPatchRoutes(_ routes: RoutesBuilder)
}

public extension ApiPatchController {

    func patchValidators() -> [AsyncValidator] {
        []
    }
    
    func patchApi(_ req: Request) async throws -> Response {
        let hasAccess = try await patchAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        try await RequestValidator(patchValidators()).validate(req)
        let model = try await findBy(identifier(req), req)
        let input = try req.content.decode(PatchObject.self)
        try await patchInput(req, model, input)
        try await beforePatch(req, model)
        try await model.update(on: req.db)
        try await afterPatch(req, model)
        return try await patchResponse(req, model)
    }
    
    func setUpPatchRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        existingModelRoutes.patch(use: patchApi)
    }
   
}
