//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 01..
//

public struct AccessRedirectMiddleware: AsyncMiddleware {

    let permission: FeatherPermission
    let path: String

    public init(_ permission: FeatherPermission, path: String = "/") {
        self.permission = permission
        self.path = path
    }

    public func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard try await req.checkAccess(for: permission) else {
            return req.redirect(to: path)
        }
        return try await next.respond(to: req)
    }
}

