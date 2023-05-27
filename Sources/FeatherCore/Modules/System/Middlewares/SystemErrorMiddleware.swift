//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 28..
//

import Vapor

struct SystemErrorMiddleware: AsyncMiddleware {
    
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: req)
        }
        catch {
            var title = "Error"
            var message = error.localizedDescription
            var status: HTTPStatus = .ok
            if let err = error as? AbortError {
                title = String(err.status.code)
                message = err.reason
                status = err.status
            }
            let template = SystemErrorPageTemplate(.init(title: title, message: message))
            return req.templates.renderHtml(template, status: status)
        }
    }
}

