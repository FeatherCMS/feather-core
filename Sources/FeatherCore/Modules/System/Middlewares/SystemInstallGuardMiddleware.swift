//
//  SystemInstallGuardMiddleware.swift
//  SystemModule
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

/// if the system is not installed we only allow system related operations
struct SystemInstallGuardMiddleware: Middleware {

    /// only allow the root path or the /system/ paths if the system has benn not installed yet, otherwise redirect to the root
    func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        var acceptedUrl = "/install/"
        if let step = Application.Config.installStep, step != InstallStep.start.key {
            acceptedUrl += step + "/"
        }
        if !Application.Config.installed && req.url.path != acceptedUrl {
            return req.eventLoop.future(req.redirect(to: acceptedUrl))
        }
        return next.respond(to: req)
        
    }
    
}
