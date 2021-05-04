//
//  DeleteViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//


public protocol DeleteApiRepresentable: ModelApi {}

public struct DeleteContext: Encodable {

    public let model: ModelInfo
    public let id: String
    public let token: String
    public let context: String
    public let bc: [Link]
    
    public init(model: ModelInfo, id: String, token: String, context: String, bc: [Link] = []) {
        self.model = model
        self.id = id
        self.token = token
        self.context = context
        self.bc = bc
    }
}

public protocol DeleteController: IdentifiableController {
 
    /// the view used to render the delete form
    var deleteView: String { get }

    /// check if there is access to delete the object, if the future the server will respond with a forbidden status
    func accessDelete(req: Request) -> EventLoopFuture<Bool>
    
    /// this will be called before the model is deleted
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model>
    
    /// deletes a model from the database
    func delete(req: Request) throws -> EventLoopFuture<Response>
    
    /// this method will be called after a succesful deletion
    func afterDelete(req: Request, model: Model) -> EventLoopFuture<Model>
    
    /// returns a response after completing the delete request
    func deleteResponse(req: Request, model: Model) -> EventLoopFuture<Response>
    
    func deleteApi(_ req: Request) throws -> EventLoopFuture<HTTPStatus>

    /// setup the get and post routes for the delete controller
    func setupDeleteRoutes(on: RoutesBuilder, as: PathComponent)
    
    func setupDeleteApiRoute(on builder: RoutesBuilder)
    
    func deleteContext(req: Request, model: Model) -> String
    
    func deleteContext(req: Request, id: String, token: String, model: Model) -> DeleteContext
}

public extension DeleteController {

    var deleteView: String { "System/Admin/Delete" }

    func accessDelete(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .delete))
    }
    
    func deleteView(req: Request) throws -> EventLoopFuture<View>  {
        accessDelete(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return findBy(try identifier(req), on: req.db).flatMap { model in
                let formId = UUID().uuidString
                let formToken = req.generateNonce(for: formId)
                let ctx = deleteContext(req: req, id: formId, token: formToken, model: model)
                return req.view.render(deleteView, ctx)
            }
        }
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Response> {
        accessDelete(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            
            let context = try req.content.decode(Form.IdTokenInput.self)
            try req.useNonce(id: context.formId, token: context.formToken)

            let id = try identifier(req)
            return findBy(id, on: req.db)
                .flatMap { beforeDelete(req: req, model: $0) }
                .flatMap { model in model.delete(on: req.db).map { model } }
                .flatMap { afterDelete(req: req, model: $0) } }
                .flatMap { deleteResponse(req: req, model: $0) }
    }

    
    func deleteApi(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        accessDelete(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return try findBy(identifier(req), on: req.db)
//                .flatMap { beforeDelete(req: req, model: $0) }
                .flatMap { $0.delete(on: req.db) }
//                .flatMap { afterDelete(req: req) }
                .transform(to: .noContent)
        }
    }

    func afterDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }

//    func deleteResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
//        req.eventLoop.future(Response(status: .ok, version: req.version))
//    }
    
    /// after we delete a model, we can redirect back to the list, using the current path component, but trimming the final uuid/delete part.
    func deleteResponse(req: Request, model: Model) -> EventLoopFuture<Response> {
        // /[model]/:id/delete -> /[model]/
        var url = req.url.path.trimmingLastPathComponents(2)
        if let redirect = try? req.content.get(String.self, at: "redirect") {
            url = redirect
        }
        return req.eventLoop.future(req.redirect(to: url))
    }

    func deleteContext(req: Request, model: Model) -> String {
        model.identifier
    }
    
    func deleteContext(req: Request, id: String, token: String, model: Model) -> DeleteContext {
        .init(model: Model.info(req), id: id, token: token, context: deleteContext(req: req, model: model))
    }
    
    func setupDeleteRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        builder.get(Model.idParamKeyPathComponent, pathComponent, use: deleteView)
        builder.post(Model.idParamKeyPathComponent, pathComponent, use: delete)
    }
    
    func setupDeleteApiRoute(on builder: RoutesBuilder) {
        builder.delete(Model.idParamKeyPathComponent, use: deleteApi)
    }
}
