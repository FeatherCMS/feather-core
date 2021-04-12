//
//  UpdateContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol UpdateContentController: IdentifiableController where Model: UpdateContentRepresentable {

    /// check if there is access to update the object, if the future the server will respond with a forbidden status
    func accessUpdate(req: Request) -> EventLoopFuture<Bool>
    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model>
    func update(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupUpdateRoute(on: RoutesBuilder)
}

public extension UpdateContentController {

    func accessUpdate(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }

    func beforeUpdate(req: Request, model: Model, content: Model.UpdateContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func update(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        accessUpdate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }

            try Model.UpdateContent.validate(content: req)
            let input = try req.content.decode(Model.UpdateContent.self)
            return try findBy(identifier(req), on: req.db)
                .flatMap { beforeUpdate(req: req, model: $0, content: input) }
                .flatMapThrowing { model -> Model in
                    try model.update(input)
                    return model
                }
                .flatMap { model -> EventLoopFuture<Model.GetContent> in
                    return model.update(on: req.db)
                        .flatMap { afterUpdate(req: req, model: model) }
                        .transform(to: model.getContent)
                }
        }
    }

    func afterUpdate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
    
    func setupUpdateRoute(on builder: RoutesBuilder) {
        builder.put(idPathComponent, use: update)
    }
}
