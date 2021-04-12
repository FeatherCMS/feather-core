//
//  ListContentController.swift
//  ContentApi
//
//  Created by Tibor Bodecs on 2020. 04. 26..
//

public protocol ListContentController: ContentController where Model: ListContentRepresentable {
    
    func accessList(req: Request) -> EventLoopFuture<Bool>
    func list(_: Request) throws -> EventLoopFuture<Page<Model.ListItem>>
    func setupListRoute(on: RoutesBuilder)
}

public extension ListContentController {

    func accessList(req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }

    func list(_ req: Request) throws -> EventLoopFuture<Page<Model.ListItem>> {
        accessList(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            return Model
                .query(on: req.db)
                .paginate(for: req)
                .map { $0.map(\.listContent) }
        }
    }
    
    func setupListRoute(on builder: RoutesBuilder) {
        builder.get(use: list)
    }

}
