//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 22..
//

struct FrontendTemplateScopeMiddleware: Middleware {

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        FrontendMenuModel.query(on: req.db).with(\.$items).all().flatMapThrowing { menus -> Void in
            var items: [String: TemplateDataGenerator] = [:]
            for menu in menus {
                items[menu.key] = .lazy(menu.items.sorted { $0.priority > $1.priority }.map { $0.encodeToTemplateData() })
            }
            try req.tau.context.register(generators: items, toScope: "menus")
        }
        .flatMap { next.respond(to: req) }
    }
}


