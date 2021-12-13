//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml

struct AdminDashboardController {
    
    func renderDashboardTemplate(_ req: Request) async throws -> Response {
        let widgets: [[TemplateRepresentable]] = await req.invokeAll(.adminWidgets)
        
        let template = AdminDashboardTemplate(req, .init(title: "Dashboard", widgets: widgets.flatMap { $0 }.map(\.tag)))
        return req.html.render(template)
    }
}
