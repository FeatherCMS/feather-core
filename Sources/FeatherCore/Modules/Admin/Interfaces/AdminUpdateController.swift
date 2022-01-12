//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public protocol AdminUpdateController: UpdateController {
    associatedtype UpdateModelEditor: FeatherModelEditor
    
    static var updatePathComponent: PathComponent { get }
    
    func updateView(_ req: Request) async throws -> Response
    func updateAction(_ req: Request) async throws -> Response
    
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor) async -> TemplateRepresentable
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext
    func updateBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext]
    
    func setupUpdateRoutes(_ routes: RoutesBuilder)
}

public extension AdminUpdateController {
    
    static var updatePathComponent: PathComponent { "update" }
    
    private func render(_ req: Request, editor: UpdateModelEditor) async -> Response {
        return req.templates.renderHtml(await updateTemplate(req, editor))
    }
    
    func updateView(_ req: Request) async throws -> Response {
        let hasAccess = try await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }

        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model, form: .init())
        editor.form.fields = editor.formFields
        try await editor.load(req: req)
        try await editor.read(req: req)
        return await render(req, editor: editor)
    }

    func updateAction(_ req: Request) async throws -> Response {
        let hasAccess = try await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model, form: .init())
        editor.form.fields = editor.formFields
        try await editor.load(req: req)
        try await editor.process(req: req)
        let isValid = try await editor.validate(req: req)
        guard isValid else {
            return await render(req, editor: editor)
        }
        try await editor.write(req: req)
        try await beforeUpdate(req, model)
        try await editor.model.update(on: req.db)
        try await afterUpdate(req, model)
        try await editor.save(req: req)
        return req.redirect(to: req.url.path)
    }
    
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor) async -> TemplateRepresentable {
        await AdminEditorPageTemplate(updateContext(req, editor))
    }
    
    func updateContext(_ req: Request, _ editor: UpdateModelEditor) async -> AdminEditorPageContext {
       .init(title: "Update " + Self.modelName.singular,
             form: editor.form.context(req),
             breadcrumbs: updateBreadcrumbs(req, editor.model as! DatabaseModel),
             links: updateNavigation(req, editor.model as! DatabaseModel),
             actions: [
                LinkContext(label: "Delete",
                            path: "delete/?redirect=" + req.url.path.pathComponents.dropLast(2).path + "&cancel=" + req.url.path,
                            dropLast: 1,
                            permission: ApiModel.permission(for: .delete).key,
                            style: .destructive),
             ])
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: DatabaseModel.Module.featherIdentifier.uppercasedFirst,
                        dropLast: 3,
                        permission: ApiModel.Module.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: ApiModel.permission(for: .detail).key),
        ]
    }
    
    func setupUpdateRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)

        let existingModelRoutes = baseRoutes.grouped(ApiModel.pathIdComponent)
        
        existingModelRoutes.get(Self.updatePathComponent, use: updateView)
        existingModelRoutes.post(Self.updatePathComponent, use: updateAction)
    }
}
