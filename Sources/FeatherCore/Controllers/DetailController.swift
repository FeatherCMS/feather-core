//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import Foundation

public protocol DetailController: ModelController {
    associatedtype DetailModelApi: DetailApi

    func detailAccess(_ req: Request) async -> Bool
    func detailView(_ req: Request) async throws -> Response
    func detailApi(_ req: Request) async throws -> DetailModelApi.DetailObject
    func detailTemplate(_ req: Request, _ model: Model) -> TemplateRepresentable
}

public extension DetailController {
    
    func detailAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Model.permission(.detail))
    }

    func detailView(_ req: Request) async throws -> Response {
        let model = try await findBy(identifier(req), on: req.db)
        return req.html.render(detailTemplate(req, model))
    }

    func detailApi(_ req: Request) async throws -> DetailModelApi.DetailObject {
        let hasAccess = await detailAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db) as! DetailModelApi.Model
        let api = DetailModelApi()
        return api.mapDetail(model: model)
    }
}
