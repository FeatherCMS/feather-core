//
//  UserAccessMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 03..
//

public struct AccessGuardMiddleware: Middleware {

    public let permission: Permission

    public init(_ permission: Permission) {
        self.permission = permission
    }

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return req.checkAccess(for: permission).flatMap { hasAccess in
            if hasAccess {
                return next.respond(to: req)
            }
            return req.eventLoop.future(error: Abort(.forbidden))
        }
    }
}


