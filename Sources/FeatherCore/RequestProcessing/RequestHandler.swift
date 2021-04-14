//
//  RequestProcessor.swift
//  RequestProcessing
//
//  Created by Tibor Bodecs on 2021. 03. 19..
//

 struct RequestHandler {

     let name: String?
     let method: HTTPMethod
     let pathPrefix: [PathComponent]
     let pathComponents: [PathComponent]
     let body: HTTPBodyStreamStrategy
     let middlewares: [Middleware]
     let controllers: () -> [RequestController]

     init(name: String? = nil,
                method: HTTPMethod = .GET,
                pathPrefix: [PathComponent] = [],
                pathComponents: [PathComponent] = [],
                body: HTTPBodyStreamStrategy = .collect,
                middlewares: [Middleware] = [],
                controllers: @escaping () -> [RequestController]) {
        self.name = name
        self.method = method
        self.pathPrefix = pathPrefix
        self.pathComponents = pathComponents
        self.body = body
        self.middlewares = middlewares
        self.controllers = controllers
    }


    // MARK: - helpers
    
    private var hookName: String {
        let parts = [method.rawValue] + pathPrefix.map(\.description) + pathComponents.map(\.description)
        let n = parts
            .joined(separator: "-")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: ".", with: "-")
            .lowercased()
        return name ?? n
    }
    
    // MARK: - api
    
     func handle(route routesBuilder:  RoutesBuilder) {
        /// NOTE: check for empty middlewares? unnecessary group call...
        routesBuilder.grouped(middlewares).on(method, pathComponents, body: body, use: handler)
    }

    /**
        Handle an incoming request
     
        The handler methods will be called one after another.
  
        **Call order**

            boot
                - bootResponse -> respond
                - nil -> access
            
            access (merge bools)
                - false -> accessResponse ?? Abort(.unauthorized)
                - true -> load
            
            load
                - load -> respond
                - nil -> validation
            
            validation (merge bools)
                - false -> invalid
                - true -> validationResponse ?? save
            
            failure
                 - failureResponse -> respond
                 - nil -> render (invalid state)

            success
                - successResponse -> respond
                - nil -> render (valid state)

            render
                
     */
    private func handler(req: Request) -> EventLoopFuture<Response> {
        /// find the request handlers and sort them by priority
        let otherControllers: [() -> [RequestController]] = req.invokeAll(hookName + "-request-controllers")
        let ctrls = controllers() + otherControllers.map { $0() }.flatMap { $0 }.sorted { $0.priority > $1.priority }

        /// boot the controllers
        return req.eventLoop.flatten(ctrls.map { $0.boot(req: req) }).flatMap {
            /// return with a boot response if needed
            return req.eventLoop.findFirstValue(ctrls.map { $0.bootResponse(req: req) }).flatMap { response in
                if let response = response {
                    return req.eventLoop.future(response)
                }
                /// check access
                let accessFuture = req.eventLoop.mergeTrueFutures(ctrls.map { $0.access(req: req) })
                return accessFuture.flatMap { hasAccess -> EventLoopFuture<Response> in
                    guard hasAccess else {
                        /// return access response or abort
                        return req.eventLoop.findFirstValue(ctrls.map { $0.accessResponse(req: req) }).unwrap(or: Abort(.unauthorized))
                    }
                    /// load objects if needed
                    return req.eventLoop.flatten(ctrls.map { $0.load(req: req) }).flatMap {
                        /// return with a load response if needed
                        return req.eventLoop.findFirstValue(ctrls.map { $0.loadResponse(req: req) }).flatMap { response in
                            if let response = response {
                                return req.eventLoop.future(response)
                            }
                            /// validate
                            let validationFuture = req.eventLoop.mergeTrueFutures(ctrls.map { $0.validation(req: req) })
                            return validationFuture.flatMap { isValid -> EventLoopFuture<Response> in
                                guard isValid else {
                                    /// call failure methods
                                    return req.eventLoop.flatten(ctrls.map { $0.failure(req: req) }).flatMap {
                                        /// return with an failure response if needed
                                        return req.eventLoop.findFirstValue(ctrls.map { $0.failureResponse(req: req) }).flatMap { response in
                                            if let response = response {
                                                return req.eventLoop.future(response)
                                            }
                                            /// respond (failure)
                                            return req.eventLoop.findFirstValue(ctrls.map { $0.response(req: req) }).flatMap { response in
                                                if let response = response {
                                                    return req.eventLoop.future(response)
                                                }
                                                return req.eventLoop.future(error: Abort(.noContent))
                                            }
                                        }
                                    }
                                }
                                /// return with a validation response if needed
                                return req.eventLoop.findFirstValue(ctrls.map { $0.validationResponse(req: req) }).flatMap { response in
                                    if let response = response {
                                        return req.eventLoop.future(response)
                                    }
                                    /// save the objects
                                    return req.eventLoop.flatten(ctrls.map { $0.success(req: req) }).flatMap {
                                        /// return with a save response if needed
                                        return req.eventLoop.findFirstValue(ctrls.map { $0.successResponse(req: req) }).flatMap { response in
                                            if let response = response {
                                                return req.eventLoop.future(response)
                                            }
                                            /// respond (success)
                                            return req.eventLoop.findFirstValue(ctrls.map { $0.response(req: req) }).flatMap { response in
                                                if let response = response {
                                                    return req.eventLoop.future(response)
                                                }
                                                return req.eventLoop.future(error: Abort(.noContent))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
