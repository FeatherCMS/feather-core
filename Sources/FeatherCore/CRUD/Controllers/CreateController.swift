//
//  CreateViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 12. 04..
//



public protocol CreateApiRepresentable: ModelApi {
    
    associatedtype CreateObject: Codable
    
    func validateCreate(_ req: Request) -> EventLoopFuture<[ValidationError]>
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void>
}

extension CreateApiRepresentable {
    func validateCreate(_ req: Request) -> EventLoopFuture<[ValidationError]> {
        return req.eventLoop.future([])
    }
}

public protocol CreateController: ModelController {

    associatedtype CreateApi: CreateApiRepresentable & GetApiRepresentable
    associatedtype CreateForm: FeatherForm

    var createView: String { get }

    func renderCreate(req: Request, context: CreateForm) -> EventLoopFuture<View>
    func accessCreate(req: Request) -> EventLoopFuture<Bool>
    func beforeCreate(req: Request, model: Model) -> EventLoopFuture<Model>
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void>

    func createView(req: Request) throws -> EventLoopFuture<View>
    func create(req: Request) throws -> EventLoopFuture<Response>
    func createApi(_ req: Request) throws -> EventLoopFuture<CreateApi.GetObject>

    func setupCreateRoutes(on: RoutesBuilder, as: PathComponent)
    func setupCreateApiRoute(on builder: RoutesBuilder)
}

public extension CreateController {

    var createView: String { "System/Admin/Edit" }

    func renderCreate(req: Request, context: CreateForm) -> EventLoopFuture<View> {
        req.view.render(createView, context)
    }

    func accessCreate(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .create))
    }
    
    func beforeCreate(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    // MARK: - route handlers

    func createView(req: Request) throws -> EventLoopFuture<View> {
        accessCreate(req: req).flatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let createFormController = CreateForm()
            return createFormController.load(req: req).flatMap {
                renderCreate(req: req, context: createFormController)
            }
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        accessCreate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }

            let createFormController = CreateForm()
            return createFormController.load(req: req)
                .flatMap { createFormController.process(req: req) }
                .flatMap { createFormController.validate(req: req) }
                .flatMap { isValid in
                    guard isValid else {
                        return renderCreate(req: req, context: createFormController).encodeResponse(for: req)
                    }
                    let model = Model()
                    createFormController.context.model = model as? CreateForm.Model
                    return createFormController.write(req: req)
                        .flatMap { beforeCreate(req: req, model: model) }
                        .flatMap { model in model.create(on: req.db).map { model } }
                        .flatMap { afterCreate(req: req, model: $0) }
                        .flatMap { model in createFormController.save(req: req).map { model } }
                        .map {
                            req.redirect(to: req.url.path.replacingLastPath(model.identifier) + "/" + Model.updatePathComponent.description + "/")
                        }
            }
        }
    }    

    func createApi(_ req: Request) throws -> EventLoopFuture<CreateApi.GetObject> {
        accessCreate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }

            let api = CreateApi()

            return api.validateCreate(req).flatMap { errors -> EventLoopFuture<CreateApi.Model> in
                guard errors.isEmpty else {
                    return req.eventLoop.future(error: ValidationAbort(abort: Abort(.badRequest), details: errors))
                }
                do {
                    let input = try req.content.decode(CreateApi.CreateObject.self)
                    let model = Model() as! CreateApi.Model
                    return api.mapCreate(req, model: model, input: input).flatMap {
                        req.eventLoop.future(model)
                    }
                }
                catch {
                    return req.eventLoop.future(error: Abort(.badRequest))
                }
            }
            .flatMap { model in model.create(on: req.db).map { model } }
            .map { api.mapGet(model: $0) }
        }
    }

    func setupCreateRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        builder.get(pathComponent, use: createView)
        builder.on(.POST, pathComponent, use: create)
    }
    
    func setupCreateApiRoute(on builder: RoutesBuilder) {
        builder.post(use: createApi)
    }
}

