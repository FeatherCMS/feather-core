//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 10..
//

fileprivate extension Application {

    var templateScopeGenerator: [String: TemplateDataGenerator] {
        [
            "isDebug": .lazy(TemplateData.bool(!self.environment.isRelease && self.environment != .production)),
            "baseUrl": .lazy(TemplateData.string(Application.baseUrl)),
            "timezone": .lazy(Application.Config.timezone.identifier),
            "locale": .lazy(Application.Config.locale.identifier),
            "dateFormats": .lazy([
                "full": TemplateData.string(Application.Config.dateFormatter().dateFormat),
                "date": TemplateData.string(Application.Config.dateFormatter(timeStyle: .none).dateFormat),
                "time": TemplateData.string(Application.Config.dateFormatter(dateStyle: .none).dateFormat),
            ]),
        ]
    }
}


fileprivate extension Request {

    var templateScopeGenerator: [String: TemplateDataGenerator] {
        [
            "url": .lazy([
                "isSecure": TemplateData.bool(self.url.scheme?.contains("https")),
                "host": TemplateData.string(self.url.host),
                "port": TemplateData.int(self.url.port),
                "path": TemplateData.string(self.url.path),
                "query": TemplateData.string(self.url.query)
            ]),
        ]
    }
}


struct SystemTemplateScopeMiddleware: Middleware {

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        req.eventLoop.flatten([
            /// add menus to the scope
            SystemMenuModel.query(on: req.db).with(\.$items).all().map { menus -> [String: [String: TemplateDataGenerator]] in
                var items: [String: TemplateDataGenerator] = [:]
                for menu in menus {
                    items[menu.key] = .lazy(menu.items.sorted { $0.priority > $1.priority }.map { $0.encodeToTemplateData() })
                }
                return ["menus": items]
            },
            /// add variables to the scope
            SystemVariableModel.query(on: req.db).all().map { variables in
                var items: [String: TemplateDataGenerator] = [:]
                for variable in variables {
                    items[variable.key] = .immediate(variable.value)
                }
                return ["variables": items]
            },
        ])
        .flatMapEachThrowing { generators in
            for (scope, generator) in generators {
                try req.tau.context.register(generators: generator, toScope: scope)
            }
        }
        .flatMapThrowing { _ in
            let user: [String: TemplateDataGenerator] = [
                "isAuthenticated": .lazy(TemplateData.bool(req.auth.has(User.self))),
                "email": .lazy(TemplateData.string(req.auth.get(User.self)?.email)),
            ]

            try req.tau.context.register(generators: req.application.templateScopeGenerator, toScope: "app")
            try req.tau.context.register(generators: req.templateScopeGenerator, toScope: "req")
            try req.tau.context.register(generators: user, toScope: "user")
        }
        .flatMap { _ in next.respond(to: req) }
    }
}


