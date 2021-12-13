//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 21..
//

import Vapor

struct MyMiddleware: AsyncMiddleware {

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        print("foo")
        return try await next.respond(to: request)
    }
}
