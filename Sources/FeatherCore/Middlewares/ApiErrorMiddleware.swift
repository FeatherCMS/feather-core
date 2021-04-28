//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

struct ValidationAbort: AbortError {
    var abort: Abort
    var errors: [ValidationError]

    var reason: String { abort.reason }
    var status: HTTPStatus { abort.status }
}

struct ApiErrorMiddleware: Middleware {
    
    let environment: Environment
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapErrorThrowing { error in
            let status: HTTPResponseStatus
            let headers: HTTPHeaders
            let issues: [ValidationError]

            switch error {
            case let abort as ValidationAbort:
                status = abort.abort.status
                headers = abort.abort.headers
                issues = abort.errors
            default:
                status = .internalServerError
                headers = [:]
                issues = []
            }

            request.logger.report(error: error)

            let response = Response(status: status, headers: headers)

            do {
                response.body = try .init(data: JSONEncoder().encode(issues))
                response.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
            }
            catch {
                response.body = .init(string: "Oops: \(error)")
                response.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
            }
            return response
        }
    }
}
