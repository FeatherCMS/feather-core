//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import Vapor

public struct DetailField<T> {

    let block: (T, Request) async throws -> DetailContext
    
    public init(_ block: @escaping (T, Request) async throws -> DetailContext) {
        self.block = block
    }
}


public protocol AdminDetailController: DetailController {
    func detailView(_ req: Request) async throws -> Response
    func detailTemplate(_ req: Request, _ model: DatabaseModel) async throws -> TemplateRepresentable
    
    func detailFields() -> [DetailField<DatabaseModel>]
    func detailFields(for model: DatabaseModel) -> [DetailContext]
    func detailContext(_ req: Request, _ model: DatabaseModel) async throws -> SystemAdminDetailPageContext
    func detailTitle(_ req: Request, _ model: DatabaseModel) -> String
    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    func detailActions(_ req: Request, _ model: DatabaseModel) -> [LinkContext]    
    
    func setUpDetailRoutes(_ routes: RoutesBuilder)
}

public extension AdminDetailController {
    
    
    func detailFields() -> [DetailField<DatabaseModel>] {
        []
    }
    
    func detailView(_ req: Request) async throws -> Response {
        let hasAccess = try await detailAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        
        let model = try await findBy(identifier(req), req)
        return req.templates.renderHtml(try await detailTemplate(req, model))
    }

    func detailTemplate(_ req: Request, _ model: DatabaseModel) async throws -> TemplateRepresentable {
        SystemAdminDetailPageTemplate(try await detailContext(req, model))
    }

    func detailContext(_ req: Request, _ model: DatabaseModel) async throws -> SystemAdminDetailPageContext {
        var ctx = try await detailFields().mapAsync { try await $0.block(model, req) }
        if ctx.isEmpty {
            ctx = detailFields(for: model)
        }
        
        return .init(title: detailTitle(req, model),
              fields: ctx,
              navigation: detailNavigation(req, model),
              breadcrumbs: detailBreadcrumbs(req, model),
              actions: detailActions(req, model))
    }
    
    func detailTitle(_ req: Request, _ model: DatabaseModel) -> String  {
        Self.modelName.singular + " details"
    }

    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: Self.moduleName,
                        dropLast: 2,
                        permission: ApiModel.Module.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }

    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Edit",
                        path: "update",
                        permission: ApiModel.permission(for: .update).key),
        ]
    }
    
    func detailActions(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Delete",
                        path: "/delete/?redirect=" + req.url.path.pathComponents.dropLast().path + "&cancel=" + req.url.path,
                        permission: ApiModel.permission(for: .delete).key,
                        style: .destructive),
        ]
    }
    
    
    func setUpDetailRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
                
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        
        existingModelRoutes.get(use: detailView)
    }
}
