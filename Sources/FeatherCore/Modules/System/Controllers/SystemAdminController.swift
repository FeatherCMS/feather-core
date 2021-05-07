//
//  AdminController.swift
//  AdminModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct SystemAdminController {

    func homeView(req: Request) throws -> EventLoopFuture<View> {
        let menus: [HookObjects.AdminMenu] = req.invokeAll(.adminMenu)

        return req.view.render("System/Admin/Home", [
            "menus": menus.sorted { $0.item.priority > $1.item.priority }
        ])
    }
    
    func modulesView(req: Request) throws -> EventLoopFuture<View> {
        req.view.render("System/Admin/Modules", [
            "modules": req.application.feather.modules.map { type(of: $0).name }
        ])
    }
    
    func dashboardView(req: Request) throws -> EventLoopFuture<View> {
        let widgets: [EventLoopFuture<View>] = req.invokeAll(.adminWidget)
        
        return req.eventLoop.flatten(widgets)
        .mapEach { $0.data.getString(at: 0, length: $0.data.readableBytes) }
        .flatMap { items -> EventLoopFuture<View> in
            let widgets = items.compactMap { $0 }
            return req.view.render("System/Admin/Dashboard", ["widgets": widgets])
        }
    }
    
    
    
}
