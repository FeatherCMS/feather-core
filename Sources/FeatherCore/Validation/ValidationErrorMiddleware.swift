//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

struct ValidationErrorMiddleware: Middleware {

    let environment: Environment

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapErrorThrowing { error in
            let status: HTTPResponseStatus
            let headers: HTTPHeaders
            let message: String?
            let details: [ValidationErrorDetail]

            switch error {
            case let abort as ValidationAbort:
                status = abort.abort.status
                headers = abort.abort.headers
                message = abort.message
                details = abort.details
            case let abort as Abort:
                status = abort.status
                headers = abort.headers
                message = abort.reason
                details = []
            default:
                status = .internalServerError
                headers = [:]
                message = environment.isRelease ? "Something went wrong." : error.localizedDescription
                details = []
            }

            request.logger.report(error: error)

            let response = Response(status: status, headers: headers)

            do {
                response.body = try .init(data: JSONEncoder().encode(ValidationError(message: message, details: details)))
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
