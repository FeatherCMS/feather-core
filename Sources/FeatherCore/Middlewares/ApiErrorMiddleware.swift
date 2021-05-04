//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 28..
//

/*
API error format:

```json
{
    // optional:
    "message": "There is a general issue with the input",
    
    "details": [
        {
           "key": "key",
           "message": "Key must be unique",
        },
        {
           "key": "name",
           "message": "Name is required",
        },
    ]
}
```
*/

struct ValidationAbort: AbortError {

    var abort: Abort
    var message: String?
    var details: [ValidationError]

    var reason: String { abort.reason }
    var status: HTTPStatus { abort.status }
    
    init(abort: Abort, message: String? = nil, details: [ValidationError]) {
        self.abort = abort
        self.message = message
        self.details = details
    }
}

struct ApiError: Codable {
    let message: String?
    let details: [ValidationError]
}

extension ApiError: Content {}

struct ApiErrorMiddleware: Middleware {
    
    let environment: Environment

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapErrorThrowing { error in
            let status: HTTPResponseStatus
            let headers: HTTPHeaders
            let message: String?
            let details: [ValidationError]

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
                response.body = try .init(data: JSONEncoder().encode(ApiError(message: message, details: details)))
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
