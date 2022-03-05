//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor

public protocol ApiDetailController: DetailController {
    associatedtype DetailObject: Content
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> DetailObject
    func detailApi(_ req: Request) async throws -> DetailObject
    func setUpDetailRoutes(_ routes: RoutesBuilder)
}

public extension ApiDetailController {
    func detailApi(_ req: Request) async throws -> DetailObject {
        let hasAccess = try await detailAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), req)
        return try await detailOutput(req, model)
    }
    
    func setUpDetailRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        existingModelRoutes.get(use: detailApi)
    }
}
