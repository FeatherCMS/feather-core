//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor

struct AdminErrorMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: req)
        }
        catch {
            var title = "Error"
            var message = error.localizedDescription
            if let err = error as? AbortError {
                title = String(err.status.code)
                message = err.reason
            }
            let template = AdminErrorTemplate(req, .init(title: title, message: message))
            return req.html.render(template)
        }
    }
}

