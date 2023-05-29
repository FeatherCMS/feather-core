//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor

struct SystemAdminDashboardController {

    func renderDashboardTemplate(_ req: Request) async throws -> Response {
        let asyncWidgets: [TemplateRepresentable] = try await req.invokeAllFlatAsync(.adminWidgets)
        let widgets: [TemplateRepresentable] = req.invokeAllFlat(.adminWidgets)
        let tags = (widgets + asyncWidgets).map { $0.render(req) }
        let template = SystemAdminDashboardTemplate(.init(title: "Dashboard", widgets: tags))
        return req.templates.renderHtml(template)
    }
}
