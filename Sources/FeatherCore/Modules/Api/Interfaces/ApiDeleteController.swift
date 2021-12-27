//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

public protocol ApiDeleteController: DeleteController {
    
    func deleteApi(_ req: Request) async throws -> HTTPStatus
    func setupDeleteRoutes(_ routes: RoutesBuilder)
}

public extension ApiDeleteController {

    func deleteApi(_ req: Request) async throws -> HTTPStatus {
        let hasAccess = try await deleteAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db)
        try await beforeDelete(req, model)
        try await model.delete(on: req.db)
        try await afterDelete(req, model)
        return .noContent
    }
    
    func setupDeleteRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        existingModelRoutes.delete(use: deleteApi)
    }
}
