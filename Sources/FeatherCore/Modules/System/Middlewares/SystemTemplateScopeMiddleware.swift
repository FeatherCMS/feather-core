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
                "full": TemplateData.string(Application.dateFormatter().dateFormat),
                "date": TemplateData.string(Application.dateFormatter(timeStyle: .none).dateFormat),
                "time": TemplateData.string(Application.dateFormatter(dateStyle: .none).dateFormat),
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
        do {
            try req.tau.context.register(generators: req.application.templateScopeGenerator, toScope: "app")
            try req.tau.context.register(generators: req.templateScopeGenerator, toScope: "req")
            return next.respond(to: req)
        }
        catch {
            return req.eventLoop.future(error: error)
        }
    }
}
