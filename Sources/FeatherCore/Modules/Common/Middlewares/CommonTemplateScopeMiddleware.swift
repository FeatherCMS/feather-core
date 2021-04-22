//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

struct CommonTemplateScopeMiddleware: Middleware {

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        CommonVariableModel.query(on: req.db).all().flatMapThrowing { variables in
            var items: [String: TemplateDataGenerator] = [:]
            for variable in variables {
                items[variable.key] = .lazy(variable.value)
            }
            try req.tau.context.register(generators: items, toScope: "variables")
        }
        .flatMap { next.respond(to: req) }
    }
}


