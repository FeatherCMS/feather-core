//
//  UserAccessMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 03..
//

public struct UserAccessMiddleware: Middleware {

    public let name: String
    
    public init(name: String) {
        self.name = name
    }

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        /// check user access and respond if the user has access, otherwise return a forbidden response
        return req.checkUserAccess(name).flatMap { hasAccess in
            if hasAccess {
                return next.respond(to: req)
            }
            return req.eventLoop.future(error: Abort(.forbidden))
        }
    }
}

public extension RoutesBuilder {

    func userAccess(_ name: String) -> RoutesBuilder {
        grouped(UserAccessMiddleware(name: name))
    }
}
