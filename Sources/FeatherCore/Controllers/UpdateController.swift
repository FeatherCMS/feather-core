//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent

public protocol UpdateController: ModelController {
 
    associatedtype UpdateModelEditor: FeatherModelEditor
    associatedtype UpdateModelApi: UpdateApi & DetailApi

    static func updatePermission() -> FeatherPermission
    static func updatePermission() -> String
    static func hasUpdatePermission(_ req: Request) -> Bool
    
    func updateAccess(_ req: Request) async -> Bool
    func update(_ req: Request) async throws -> Response
    func updateView(_ req: Request) async throws -> Response
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor) async -> TemplateRepresentable
    func updateApi(_ req: Request) async throws -> UpdateModelApi.DetailObject
}

public extension UpdateController {
    
    static func updatePermission() -> FeatherPermission {
        Model.permission(.update)
    }
    
    static func updatePermission() -> String {
        updatePermission().rawValue
    }
    
    static func hasUpdatePermission(_ req: Request) -> Bool {
        req.checkPermission(updatePermission())
    }
    
    func updateAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Self.updatePermission())
    }
    
    private func render(_ req: Request, editor: UpdateModelEditor) async -> Response {
        return req.html.render(await updateTemplate(req, editor))
    }
    
    func updateView(_ req: Request) async throws -> Response {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }

        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model, form: .init())
        editor.form.fields = editor.formFields
        await editor.load(req: req)
        await editor.read(req: req)
        return await render(req, editor: editor)
    }

    func update(_ req: Request) async throws -> Response {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model, form: .init())
        editor.form.fields = editor.formFields
        await editor.load(req: req)
        await editor.process(req: req)
        let isValid = await editor.validate(req: req)
        guard isValid else {
            return await render(req, editor: editor)
        }
        await editor.write(req: req)
        try await editor.model.update(on: req.db)
        await editor.save(req: req)
        return req.redirect(to: req.url.path)
    }

    func updateApi(_ req: Request) async throws -> UpdateModelApi.DetailObject {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = UpdateModelApi()
        try await RequestValidator(api.updateValidators()).validate(req)
        let model = try await findBy(identifier(req), on: req.db) as! UpdateModelApi.Model
        let input = try req.content.decode(UpdateModelApi.UpdateObject.self)
        await api.mapUpdate(req, model: model, input: input)
        try await model.update(on: req.db)
        return api.mapDetail(model: model)
    }
        
}
