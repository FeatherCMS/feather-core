//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//


public protocol AdminDetailController: DetailController {
    func detailView(_ req: Request) async throws -> Response
    func detailTemplate(_ req: Request, _ model: DatabaseModel) -> TemplateRepresentable
    
    func detailFields(for model: DatabaseModel) -> [FieldContext]
    func detailContext(_ req: Request, _ model: DatabaseModel) -> AdminDetailPageContext
    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    func detailLinks(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    
    func setupDetailRoutes(_ routes: RoutesBuilder)
}

public extension AdminDetailController {
    
    func detailView(_ req: Request) async throws -> Response {
        let model = try await findBy(identifier(req), on: req.db)
        return req.templates.renderHtml(detailTemplate(req, model))
    }

    func detailTemplate(_ req: Request, _ model: DatabaseModel) -> TemplateRepresentable {
        AdminDetailPageTemplate(detailContext(req, model))
    }

    func detailContext(_ req: Request, _ model: DatabaseModel) -> AdminDetailPageContext {
        .init(title: Self.modelName.singular.uppercasedFirst + " details",
              fields: detailFields(for: model),
              breadcrumbs: detailBreadcrumbs(req, model),
              links: detailLinks(req, model),
              actions: [
                LinkContext(label: "Delete",
                            path: "/delete/?redirect=" + req.url.path.pathComponents.dropLast().path + "&cancel=" + req.url.path,
                            permission: ApiModel.permission(for: .delete).key,
                            style: .destructive),
              ])
    }

    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: DatabaseModel.Module.featherIdentifier.uppercasedFirst,
                        dropLast: 2,
                        permission: nil), //Model.Module.permission.key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }

    func detailLinks(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: "update",
                        permission: ApiModel.permission(for: .update).key),
        ]
    }
    
    func setupDetailRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
                
        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        
        existingModelRoutes.get(use: detailView)
    }
}
