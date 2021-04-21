//
//  FrontendSafePathMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 02. 16..
//

/// converts a path into a safePath by removing duplicate / characters and redirects to the safe path if necessary
struct FrontendSafePathMiddleware: Middleware {

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let newPath = req.url.path.safePath()
        if req.url.path != newPath {
            return req.eventLoop.future(req.redirect(to: newPath))
        }
        return next.respond(to: req)
    }
}
