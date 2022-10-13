//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

import Vapor
import FeatherObjects

public protocol AdminCreateController: CreateController {
    associatedtype CreateModelEditor: FeatherModelEditor
        
    static var createPathComponent: PathComponent { get }
    
    func createTemplate(_ req: Request, _ editor: CreateModelEditor) -> TemplateRepresentable

    func createView(_ req: Request) async throws -> Response
    func createAction(_ req: Request) async throws -> Response
    
    func createContext(_ req: Request, _ editor: CreateModelEditor) -> SystemAdminEditorPageContext
    func createBreadcrumbs(_ req: Request) -> [LinkContext]
    
    func setUpCreateRoutes(_ routes: RoutesBuilder)
}

public extension AdminCreateController {

    static var createPathComponent: PathComponent { "create" }
    private func render(_ req: Request, editor: CreateModelEditor) -> Response {
        return req.templates.renderHtml(createTemplate(req, editor))
    }

    func createView(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let editor = CreateModelEditor(model: .init(), form: .init())
        editor.form.fields = editor.createFields(req)
        try await editor.load(req: req)
        return render(req, editor: editor)
    }
    
    func createAction(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = DatabaseModel()
        try await afterModelSetup(req, model)
        let editor = CreateModelEditor(model: model as! CreateModelEditor.Model, form: .init())
        editor.form.fields = editor.createFields(req)

        try await editor.load(req: req)
        try await editor.process(req: req)
        let isValid = try await editor.validate(req: req)
        guard isValid else {
            return render(req, editor: editor)
        }
        try await editor.write(req: req)
        try await beforeCreate(req, model)
        try await editor.model.create(on: req.db)
        try await afterCreate(req, model)
        try await editor.save(req: req)
        var components = req.url.path.pathComponents.dropLast()
        components += [
            editor.model.uuid.string.pathComponent
        ]
        return req.redirect(to: editor.form.getFormRedirect(req) ?? components.path)
    }
    
    func createTemplate(_ req: Request, _ editor: CreateModelEditor) -> TemplateRepresentable {
        SystemAdminEditorPageTemplate(createContext(req, editor))
    }

    func createContext(_ req: Request, _ editor: CreateModelEditor) -> SystemAdminEditorPageContext {
        .init(title: "Create " + Self.modelName.singular,
              form: editor.form.context(req),
              breadcrumbs: createBreadcrumbs(req))
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: Self.moduleName,
                        dropLast: 2,
                        permission: ApiModel.Module.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func setUpCreateRoutes(_ routes: RoutesBuilder) {
        let baseRoutes = getBaseRoutes(routes)
        baseRoutes.get(Self.createPathComponent, use: createView)
        baseRoutes.post(Self.createPathComponent, use: createAction)
    }
    
}
