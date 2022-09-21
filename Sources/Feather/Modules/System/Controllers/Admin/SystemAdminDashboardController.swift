//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import Feather

struct SystemAdminDashboardController {

    /*
        widget group hook
     
            [WidgetGroup]
    
        widget group cards hook
        WidgetGroup id = String
    
            [String: [TemplateRepresentable]]
     */
    func renderDashboardTemplate(_ req: Request) async throws -> Response {
        
        let widgetGroups: [WidgetGroup] = try await req.invokeAllFlatAsync(.adminWidgetGroups)
        
        var groups: [SystemAdminDashboardContext.WidgetGroupContext] = []

        for group in widgetGroups {
            
            var args = HookArguments()
            args["widgetGroup"] = group
            
            let asyncWidgets: [TemplateRepresentable] = try await req.invokeAllFlatAsync(.adminWidgets, args: args)
            /// legacy support
            let widgets: [TemplateRepresentable] = req.invokeAllFlat(.adminWidgets, args: args)
        
            let tags = (widgets + asyncWidgets).map { $0.render(req) }
            groups.append(.init(id: group.id, title: group.title, excerpt: group.excerpt, tags: tags))
        }
        
        let template = SystemAdminDashboardTemplate(.init(title: "Dashboard", groups: groups))
        return req.templates.renderHtml(template)
    }
}










