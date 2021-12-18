//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent

public protocol CreateController: ModelController {
    associatedtype CreateModelEditor: FeatherModelEditor
    associatedtype CreateModelApi: CreateApi & DetailApi
    
    static func createPermission() -> UserPermission
    static func createPermission() -> String
    static func hasCreatePermission(_ req: Request) -> Bool

    func createAccess(_ req: Request) async throws -> Bool
    func beforeCreate(_ req: Request, model: Model) async throws
    func create(_ req: Request) async throws -> Response
    func createView(_ req: Request) async throws -> Response
    func createTemplate(_ req: Request, _ editor: CreateModelEditor) -> TemplateRepresentable
    func createApi(_ req: Request) async throws -> Response
}

public extension CreateController {

    func beforeCreate(_ req: Request, model: Model) async throws {}

    static func createPermission() -> UserPermission {
        Model.permission(.create)
    }
    
    static func createPermission() -> String {
        createPermission().key
    }
    
    static func hasCreatePermission(_ req: Request) -> Bool {
        req.checkPermission(createPermission())
    }

    func createAccess(_ req: Request) async throws -> Bool {
        try await req.checkAccess(for: Self.createPermission())
    }
    
    private func render(_ req: Request, editor: CreateModelEditor) -> Response {
        return req.html.render(createTemplate(req, editor))
    }

    func createView(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let editor = CreateModelEditor(model: .init(), form: .init())
        editor.form.fields = editor.formFields
//        var arguments = HookArguments()
//        arguments["model"] = editor.model
//        let fields: [FormComponent] = await req.invokeAllFlat("form-fields", args: arguments)
        try await editor.load(req: req)
        return render(req, editor: editor)
    }
    
    func create(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let editor = CreateModelEditor(model: .init(), form: .init())
        editor.form.fields = editor.formFields
        try await editor.load(req: req)
        try await editor.process(req: req)
        let isValid = try await editor.validate(req: req)
        guard isValid else {
            return render(req, editor: editor)
        }
        try await editor.write(req: req)
        try await beforeCreate(req, model: editor.model as! Model)
        try await editor.model.create(on: req.db)
        try await editor.save(req: req)
        var components = req.url.path.pathComponents.dropLast()
        components += [
            editor.model.identifier.pathComponent
        ]
        return req.redirect(to: components.path)
    }
    
    func createApi(_ req: Request) async throws -> Response {
        let hasAccess = try await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = CreateModelApi()
        try await RequestValidator(api.createValidators()).validate(req)
        let input = try req.content.decode(CreateModelApi.CreateObject.self)
        let model = Model() as! CreateModelApi.Model
        try await api.mapCreate(req, model: model, input: input)
        try await model.create(on: req.db)
        return try await api.mapDetail(req, model: model)
            .encodeResponse(status: .created, for: req)
    }
}

