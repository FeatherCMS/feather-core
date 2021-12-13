//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebErrorMiddleware: AsyncMiddleware {

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
            let template = WebErrorTemplate(req, context: .init(index: .init(title: title + " - " + message),
                                                                title: title,
                                                                message: message))
            return req.html.render(template)
        }
    }
}

