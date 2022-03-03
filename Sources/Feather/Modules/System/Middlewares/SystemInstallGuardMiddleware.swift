//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

struct SystemInstallGuardMiddleware: AsyncMiddleware {

    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let allowedUrl = "/" + req.feather.config.paths.install + "/" + req.feather.config.install.currentStep + "/"
        if !req.feather.config.install.isCompleted && req.url.path != allowedUrl {
            return req.redirect(to: allowedUrl)
        }
        return try await next.respond(to: req)
    }
}
