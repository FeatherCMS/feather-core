//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

struct AdminDashboardController {
    
    func renderDashboardTemplate(_ req: Request) async throws -> Response {
        let widgets: [TemplateRepresentable] = req.invokeAllOrdered(.adminWidgets)
        let tags = widgets.map { $0.render(req) }
        let template = AdminDashboardTemplate(.init(title: "Dashboard", widgets: tags))
        return req.templates.renderHtml(template)
    }
}
