//
//  CreateContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol CreateContentController: ContentController where Model: CreateContentRepresentable {

    func accessCreate(req: Request) -> EventLoopFuture<Bool>
    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model>
    func create(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void>
    func setupCreateRoute(on: RoutesBuilder)
}

public extension CreateContentController {

    func accessCreate(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func beforeCreate(req: Request, model: Model, content: Model.CreateContent) -> EventLoopFuture<Model> {
        req.eventLoop.future(model)
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        accessCreate(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            try Model.CreateContent.validate(content: req)
            let input = try req.content.decode(Model.CreateContent.self)
            let model = Model()
            return beforeCreate(req: req, model: model, content: input).throwingFlatMap { model in
                try model.create(input)
                return model.create(on: req.db)
                        .flatMap { afterCreate(req: req, model: model) }
                        .transform(to: model.getContent)
            }
        }
    }
    
    func afterCreate(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func setupCreateRoute(on builder: RoutesBuilder) {
        builder.post(use: create)
    }
}
