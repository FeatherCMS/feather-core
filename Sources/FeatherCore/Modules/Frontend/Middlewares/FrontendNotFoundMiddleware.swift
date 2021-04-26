//
//  FrontendNotFoundMiddleware.swift
//  FrontendModule
//
//  Created by Tibor Bodecs on 2020. 04. 07..
//

struct FrontendNotFoundMiddleware: Middleware {

    /// if we found a .notFound error in the responder chain, we render our custom not found page with a 404 status code
    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        next.respond(to: req).flatMapError { error in
            if let abort = error as? AbortError, abort.status == .notFound {
                return notFound(req)
            }
            return req.eventLoop.future(error: error)
        }
    }

    func notFound(_ req: Request) -> EventLoopFuture<Response> {
        req.view.render("Frontend/NotFound").encodeResponse(status: .notFound, for: req)
    }
}
