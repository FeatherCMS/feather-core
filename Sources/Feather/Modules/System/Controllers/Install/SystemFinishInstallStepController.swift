//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor

struct SystemFinishInstallStepController: SystemInstallStepController {
    
    func installStep(_ req: Request, info: SystemInstallInfo) async throws -> Response {
        let template = SystemInstallPageTemplate(.init(icon: "🪶",
                                                       title: "Setup completed",
                                                       message: "Your site is now ready to use.",
                                                       link: .init(label: "Let's get started →",
                                                                   path: installPath(req, for: info.currentStep, next: true))))
        return req.templates.renderHtml(template)

    }
    
    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? {
        req.feather.config.install.isCompleted = true
        return req.redirect(to: "/")
    }
}
