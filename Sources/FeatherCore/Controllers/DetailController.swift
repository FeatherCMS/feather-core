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

    static func detailPermission() -> UserPermission
    static func detailPermission() -> String
    static func hasDetailPermission(_ req: Request) -> Bool

    func detailAccess(_ req: Request) async -> Bool
    func detailView(_ req: Request) async throws -> Response
    func detailApi(_ req: Request) async throws -> DetailModelApi.DetailObject
    func detailTemplate(_ req: Request, _ model: Model) -> TemplateRepresentable
}

public extension DetailController {
    
    static func detailPermission() -> UserPermission {
        Model.permission(.detail)
    }

    static func detailPermission() -> String {
        detailPermission().key
    }

    static func hasDetailPermission(_ req: Request) -> Bool {
        req.checkPermission(detailPermission())
    }
    
    func detailAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Self.detailPermission())
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
        return await api.mapDetail(req, model: model)
    }
}
