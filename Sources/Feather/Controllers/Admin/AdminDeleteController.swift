//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import Vapor
import FeatherObjects

public protocol AdminDeleteController: DeleteController {
    
    static var deletePathComponent: PathComponent { get }
    
    func deleteView(_ req: Request) async throws -> Response
    func deleteAction(_ req: Request) async throws -> Response
    
    func deleteTemplate(_ req: Request, _ model: DatabaseModel, _ form: DeleteForm) -> TemplateRepresentable
    
    func deleteInfo(_ model: DatabaseModel) -> String
    func deleteContext(_ req: Request, _ model: DatabaseModel, _ form: DeleteForm) -> SystemAdminDeletePageContext
    func deleteBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    
    func setUpDeleteRoutes(_ routes: RoutesBuilder)
}

public extension AdminDeleteController {
    
    static var deletePathComponent: PathComponent { "delete" }
    
    func deleteView(_ req: Request) async throws -> Response {
        let model = try await findBy(identifier(req), req)
        let form = DeleteForm()
        /// generate nonce token
        try await form.load(req: req)
        return req.templates.renderHtml(deleteTemplate(req, model, form))
    }
    
    func deleteAction(_ req: Request) async throws -> Response {
        let hasAccess = try await deleteAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let form = DeleteForm()
        /// validate nonce token
        let isValid = try await form.validate(req: req)
        guard isValid else {
            throw Abort(.badRequest)
        }
        let model = try await findBy(identifier(req), req)
        try await beforeDelete(req, model)
        try await model.delete(on: req.db)
        try await afterDelete(req, model)

        var url = req.url.path
        if let redirect = req.getQuery("redirect") {
            url = redirect
        }
        return req.redirect(to: url)
    }
    
    func deleteTemplate(_ req: Request, _ model: DatabaseModel, _ form: DeleteForm) -> TemplateRepresentable {
        SystemAdminDeletePageTemplate(deleteContext(req, model, form))
    }
    
    func deleteContext(_ req: Request, _ model: DatabaseModel, _ form: DeleteForm) -> SystemAdminDeletePageContext {
        .init(title: "Delete " + Self.modelName.singular,
              name: deleteInfo(model),
              type: Self.modelName.singular,
              form: form.context(req),
              breadcrumbs: deleteBreadcrumbs(req, model))
    }
    
    func deleteBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: Self.moduleName,
                        dropLast: 3,
                        permission: ApiModel.Module.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural,
                        dropLast: 2,
                        permission: ApiModel.permission(for: .list).key),
            LinkContext(label: Self.modelName.singular,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .detail).key),
        ]
    }
    
    func setUpDeleteRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        
        existingModelRoutes.get(Self.deletePathComponent, use: deleteView)
        existingModelRoutes.post(Self.deletePathComponent, use: deleteAction)
    }
}

