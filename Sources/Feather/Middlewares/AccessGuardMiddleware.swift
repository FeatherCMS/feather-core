//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

import Vapor
import FeatherApi

public struct AccessGuardMiddleware: AsyncMiddleware {

    let permission: FeatherPermission

    public init(_ permission: FeatherPermission) {
        self.permission = permission
    }

    public func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard try await req.checkAccess(for: permission) else {
            throw Abort(.forbidden)
        }
        return try await next.respond(to: req)
    }
}


