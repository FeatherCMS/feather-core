//
//  UpdateViewController.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol UpdateApiRepresentable: ModelApi {
    
    associatedtype UpdateObject: Codable
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool>
    func mapUpdate(model: Model, input: UpdateObject)
}


public protocol UpdateController: IdentifiableController {
    
    associatedtype UpdateApi: UpdateApiRepresentable & GetApiRepresentable
    associatedtype UpdateForm: FeatherForm

    var updateView: String { get }

    func accessUpdate(req: Request) -> EventLoopFuture<Bool>
    func renderUpdate(req: Request, context: UpdateForm) -> EventLoopFuture<View>
    func beforeUpdate(req: Request, model: Model) -> EventLoopFuture<Model>
    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void>

    func updateView(req: Request) throws -> EventLoopFuture<View>
    func update(req: Request) throws -> EventLoopFuture<Response>
    func updateApi(_ req: Request) throws -> EventLoopFuture<UpdateApi.GetObject>

    func setupUpdateRoutes(on builder: RoutesBuilder, as: PathComponent)
    func setupUpdateApiRoute(on builder: RoutesBuilder)
}

public extension UpdateController {
    
    var updateView: String { "System/Admin/Edit" }

    // MARK: - lifecycle & access

    func accessUpdate(req: Request) -> EventLoopFuture<Bool> {
        req.checkAccess(for: Model.permission(for: .update))
    }
    
    func renderUpdate(req: Request, context: UpdateForm) -> EventLoopFuture<View> {
        req.view.render(updateView, context)
    }
    
    func beforeUpdate(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    // MARK: - route handlers
    
    func updateView(req: Request) throws -> EventLoopFuture<View>  {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return findBy(try identifier(req), on: req.db).flatMap { model in
                let updateFormController = UpdateForm()
                updateFormController.context.model = model as? UpdateForm.Model
                return updateFormController.load(req: req)
                    .flatMap { updateFormController.read(req: req) }
                    .flatMap { renderUpdate(req: req, context: updateFormController) }
            }
        }
    }

    func update(req: Request) throws -> EventLoopFuture<Response> {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            let updateFormController = UpdateForm()
            return updateFormController.load(req: req)
                .flatMap { updateFormController.process(req: req) }
                .flatMap { updateFormController.validate(req: req) }
                .throwingFlatMap { isValid in
                    guard isValid else {
                        return renderUpdate(req: req, context: updateFormController).encodeResponse(for: req)
                    }
                    return findBy(try identifier(req), on: req.db)
                        .flatMap { model in
                            updateFormController.context.model = model as? UpdateForm.Model
                            return updateFormController.write(req: req).map { model }
                        }
                        .flatMap { beforeUpdate(req: req, model: $0) }
                        .flatMap { model in model.update(on: req.db).map { model } }
                        .flatMap { model in updateFormController.save(req: req).map { model } }
                        .flatMap { afterUpdate(req: req, model: $0) }
                        .map { req.redirect(to: req.url.path) }
                }
        }
    }
    
    func updateApi(_ req: Request) throws -> EventLoopFuture<UpdateApi.GetObject> {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return req.eventLoop.future(error: Abort(.forbidden))

//            try Model.UpdateContent.validate(content: req)
//            let input = try req.content.decode(Model.UpdateContent.self)
//            return try findBy(identifier(req), on: req.db)
//                .flatMap { beforeUpdate(req: req, model: $0, content: input) }
//                .flatMapThrowing { model -> Model in
//                    try model.update(input)
//                    return model
//                }
//                .flatMap { model -> EventLoopFuture<Model.GetContent> in
//                    return model.update(on: req.db)
//                        .flatMap { afterUpdate(req: req, model: model) }
//                        .transform(to: model.getContent)
//                }
        }
    }

    func setupUpdateRoutes(on builder: RoutesBuilder, as pathComponent: PathComponent) {
        builder.get(idPathComponent, pathComponent, use: updateView)
        builder.on(.POST, idPathComponent, pathComponent, use: update)
    }
    
    func setupUpdateApiRoute(on builder: RoutesBuilder) {
        builder.put(idPathComponent, use: updateApi)
    }
}
