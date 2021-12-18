//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent

public final class DeleteForm: FeatherForm {

    var redirect: String?
    
    public init(redirect: String? = nil) {
        self.redirect = redirect
        super.init()

        self.action.method = .post
        self.submit = "Delete"
    }

    @FormComponentBuilder
    public override func createFields() -> [FormComponent] {
        // TODO: this must be wrong, we should set the value instead of the key...
        HiddenField(redirect ?? "")
    }
}


public protocol DeleteController: ModelController {
    associatedtype DeleteModelApi: DeleteApi & DetailApi
    
    static func deletePermission() -> UserPermission
    static func deletePermission() -> String
    static func hasDeletePermission(_ req: Request) -> Bool
    
    func deleteAccess(_ req: Request) async -> Bool
    func delete(_ req: Request) async throws -> Response
    func deleteView(_ req: Request) async throws -> Response
    func deleteTemplate(_ req: Request, _ model: Model, _ form: DeleteForm) -> TemplateRepresentable
    func deleteApi(_ req: Request) async throws -> HTTPStatus
}

public extension DeleteController {
    
    static func deletePermission() -> UserPermission {
        Model.permission(.delete)
    }
    
    static func deletePermission() -> String {
        deletePermission().key
    }
    
    static func hasDeletePermission(_ req: Request) -> Bool {
        req.checkPermission(deletePermission())
    }
    
    func deleteAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Self.deletePermission())
    }

    func deleteView(_ req: Request) async throws -> Response {
        let model = try await findBy(identifier(req), on: req.db)
        let form = DeleteForm()
        /// generate nonce token
        try await form.load(req: req)
        return req.html.render(deleteTemplate(req, model, form))
    }
    
    func delete(_ req: Request) async throws -> Response {
        let hasAccess = await deleteAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let form = DeleteForm()
        /// validate nonce token
        let isValid = try await form.validate(req: req)
        guard isValid else {
            throw Abort(.badRequest)
        }
        let model = try await findBy(identifier(req), on: req.db)
        try await model.delete(on: req.db)

        var url = req.url.path//.trimmingLastPathComponents(2)
        if let redirect = try? req.content.get(String.self, at: "redirect") {
            url = redirect
        }
        return req.redirect(to: url)
    }
    
    func deleteApi(_ req: Request) async throws -> HTTPStatus {
        let hasAccess = await deleteAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db) as! DeleteModelApi.Model
        try await model.delete(on: req.db)
        return .noContent
    }
}
