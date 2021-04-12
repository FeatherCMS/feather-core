//
//  GetContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol GetContentController: IdentifiableController where Model: GetContentRepresentable {
    
    func accessGet(req: Request) -> EventLoopFuture<Bool>
    func get(_: Request) throws -> EventLoopFuture<Model.GetContent>
    func setupGetRoute(on: RoutesBuilder)
}

public extension GetContentController {

    func accessGet(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }

    func get(_ req: Request) throws -> EventLoopFuture<Model.GetContent> {
        accessGet(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return try findBy(identifier(req), on: req.db).map(\.getContent)
        }
    }

    func setupGetRoute(on builder: RoutesBuilder) {
        builder.get(idPathComponent, use: get)
    }
}

