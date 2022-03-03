//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

struct SystemAdminDashboardController {
    
    func renderDashboardTemplate(_ req: Request) async throws -> Response {
        
//        let api = SystemPermissionApi(SystemPermissionRepository(req))
//        print(try await api.create(.init(namespace: "test",
//                                         context: "permission",
//                                         action: "action",
//                                         name: "test",
//                                         notes: "test notes")))
        
        let widgets: [TemplateRepresentable] = req.invokeAllFlat(.adminWidgets)
        let tags = widgets.map { $0.render(req) }
        let template = SystemAdminDashboardTemplate(.init(title: "Dashboard", widgets: tags))
        return req.templates.renderHtml(template)
    }
}
