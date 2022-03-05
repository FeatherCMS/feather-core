//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol ApiUpdateController: UpdateController {
    associatedtype UpdateObject: Decodable
    
    func updateValidators() -> [AsyncValidator]
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: UpdateObject) async throws
    func updateApi(_ req: Request) async throws -> Response
    func updateResponse(_ req: Request, _ model: DatabaseModel) async throws -> Response
    func setUpUpdateRoutes(_ routes: RoutesBuilder)
}

public extension ApiUpdateController {

    func updateValidators() -> [AsyncValidator] {
        []
    }
    
    func updateApi(_ req: Request) async throws -> Response {
        let hasAccess = try await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        try await RequestValidator(updateValidators()).validate(req)
        let model = try await findBy(identifier(req), req)
        let input = try req.content.decode(UpdateObject.self)
        try await updateInput(req, model, input)
        try await beforeUpdate(req, model)
        try await model.update(on: req.db)
        try await afterUpdate(req, model)
        return try await updateResponse(req, model)
    }
    
    func setUpUpdateRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        existingModelRoutes.post(use: updateApi)
    }
}
