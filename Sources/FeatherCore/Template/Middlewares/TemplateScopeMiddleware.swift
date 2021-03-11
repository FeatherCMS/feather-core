//
//  File.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2021. 02. 18..
//

public struct TemplateScopeMiddleware: Middleware {
    
    public let scope: String
    public let generators: [String: TemplateDataGenerator]
    
    public init(scope: String, generators: [String: TemplateDataGenerator]) {
        self.scope = scope
        self.generators = generators
    }

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            try req.tau.context.register(generators: generators, toScope: scope)
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}
