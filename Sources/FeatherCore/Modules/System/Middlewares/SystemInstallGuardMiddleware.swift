//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

struct SystemInstallGuardMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let allowedUrl = "/" + Feather.config.paths.install + "/" + Feather.config.install.currentStep + "/"
        if !Feather.config.install.isCompleted && req.url.path != allowedUrl {
            return req.redirect(to: allowedUrl)
        }
        return try await next.respond(to: req)
    }
}
