//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//


public protocol AdminDetailController: DetailController {
    func detailView(_ req: Request) async throws -> Response
    func detailTemplate(_ req: Request, _ model: DatabaseModel) -> TemplateRepresentable
    
    func detailFields(for model: DatabaseModel) -> [DetailContext]
    func detailContext(_ req: Request, _ model: DatabaseModel) -> AdminDetailPageContext
    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    
    func setUpDetailRoutes(_ routes: RoutesBuilder)
}

public extension AdminDetailController {
    
    func detailView(_ req: Request) async throws -> Response {
        let hasAccess = try await detailAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        
        let model = try await findBy(identifier(req), on: req.db)
        return req.templates.renderHtml(detailTemplate(req, model))
    }

    func detailTemplate(_ req: Request, _ model: DatabaseModel) -> TemplateRepresentable {
        AdminDetailPageTemplate(detailContext(req, model))
    }

    func detailContext(_ req: Request, _ model: DatabaseModel) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular + " details",
              fields: detailFields(for: model),
              navigation: detailNavigation(req, model),
              breadcrumbs: detailBreadcrumbs(req, model),
              actions: [
                LinkContext(label: "Delete",
                            path: "/delete/?redirect=" + req.url.path.pathComponents.dropLast().path + "&cancel=" + req.url.path,
                            permission: ApiModel.permission(for: .delete).key,
                            style: .destructive),
              ])
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
            LinkContext(label: "Update",
                        path: "update",
                        permission: ApiModel.permission(for: .update).key),
        ]
    }
    
    func setUpDetailRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
                
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        
        existingModelRoutes.get(use: detailView)
    }
}
