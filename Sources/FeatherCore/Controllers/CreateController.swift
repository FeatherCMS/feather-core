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

    func createAccess(_ req: Request) async -> Bool
    func create(_ req: Request) async throws -> Response
    func createView(_ req: Request) async throws -> Response
    func createTemplate(_ req: Request, _ editor: CreateModelEditor, _ form: FeatherForm) -> TemplateRepresentable
    func createApi(_ req: Request) async throws -> Response
}

public extension CreateController {

    func createAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Model.permission(.create))
    }
    
    private func render(_ req: Request, editor: CreateModelEditor, form: FeatherForm) -> Response {
        return req.html.render(createTemplate(req, editor, form))
    }

    func createView(_ req: Request) async throws -> Response {
        let hasAccess = await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let editor = CreateModelEditor(model: .init())
//        var arguments = HookArguments()
//        arguments["model"] = editor.model
//        let fields: [FormComponent] = await req.invokeAllFlat("form-fields", args: arguments)
        let form = FeatherForm(fields: editor.formFields)// + fields)
        await form.load(req: req)
        return render(req, editor: editor, form: form)
    }
    
    func create(_ req: Request) async throws -> Response {
        let hasAccess = await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let editor = CreateModelEditor(model: .init())
        let form = FeatherForm(fields: editor.formFields)
        await form.load(req: req)
        await form.process(req: req)
        let isValid = await form.validate(req: req)
        guard isValid else {
            return render(req, editor: editor, form: form)
        }
        await form.write(req: req)
        try await editor.model.create(on: req.db)
        await form.save(req: req)
        return req.redirect(to: req.url.path)
    }
    
    func createApi(_ req: Request) async throws -> Response {
        let hasAccess = await createAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = CreateModelApi()
        try await RequestValidator(api.createValidators()).validate(req)
        let input = try req.content.decode(CreateModelApi.CreateObject.self)
        let model = Model() as! CreateModelApi.Model
        await api.mapCreate(req, model: model, input: input)
        try await model.create(on: req.db)
        return try await api.mapDetail(model: model).encodeResponse(status: .created, for: req)
    }
}

