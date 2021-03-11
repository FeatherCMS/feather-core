//
//  TemplateExtensionMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

struct TemplateExtensionMiddleware: Middleware {

    init() {}

    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            try req.tau.context.register(generators: req.application.featherCoreTemplateVariables, toScope: "app")
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}

extension Application {

    var featherCoreTemplateVariables: [String: TemplateDataGenerator] {
        [
            "baseUrl": .immediate(TemplateData.string(Application.baseUrl)),
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
