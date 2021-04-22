//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

struct UserTemplateScopeMiddleware: Middleware {

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            let user: [String: TemplateDataGenerator] = [
                "isAuthenticated": .lazy(TemplateData.bool(req.auth.has(User.self))),
                "email": .lazy(TemplateData.string(req.auth.get(User.self)?.email)),
            ]
            try req.tau.context.register(generators: user, toScope: "user")
            return next.respond(to: req)
        }
        catch {
            return req.eventLoop.future(error: error)
        }
    }
}


