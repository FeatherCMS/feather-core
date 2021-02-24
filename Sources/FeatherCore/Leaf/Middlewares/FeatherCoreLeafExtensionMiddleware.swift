//
//  FeatherCoreLeafExtensionMiddleware.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 20..
//

public struct FeatherCoreLeafExtensionMiddleware: Middleware {

    public init() {}

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            try req.leaf.context.register(generators: req.application.leafFeatherCore, toScope: "app")
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}

extension Application {

    var leafFeatherCore: [String: LeafDataGenerator] {
        [
            "baseUrl": .immediate(LeafData.string(Application.baseUrl)),
            "timezone": .lazy(Application.Config.timezone.identifier),
            "locale": .lazy(Application.Config.locale.identifier),
            "dateFormats": .lazy([
                "full": LeafData.string(Application.Config.dateFormatter().dateFormat),
                "date": LeafData.string(Application.Config.dateFormatter(timeStyle: .none).dateFormat),
                "time": LeafData.string(Application.Config.dateFormatter(dateStyle: .none).dateFormat),
            ]),
        ]
    }
}
