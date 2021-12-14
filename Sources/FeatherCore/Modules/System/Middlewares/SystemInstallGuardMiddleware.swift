//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor

struct SystemInstallGuardMiddleware: AsyncMiddleware {

    /// only allow the root path or the /system/ paths if the system has benn not installed yet, otherwise redirect to the root
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let acceptedUrl = "/" + Feather.config.paths.install + "/" + Feather.config.install.currentStep + "/"
        if !Feather.config.install.isCompleted && req.url.path != acceptedUrl {
            return req.redirect(to: acceptedUrl)
        }
        return try await next.respond(to: req)
    }
}
