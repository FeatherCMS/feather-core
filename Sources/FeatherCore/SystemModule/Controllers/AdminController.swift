//
//  AdminController.swift
//  AdminModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//



struct AdminController {

    func homeView(req: Request) throws -> EventLoopFuture<View> {
        let menus: [[SystemMenu]] = req.invokeAll("admin-menus")
        return req.view.render("System/Admin/Home", [
            "menus": menus.flatMap { $0 }
        ])
    }
    
    func dashboardView(req: Request) throws -> EventLoopFuture<View> {
        return req.eventLoop.flatten([
            req.view.render("System/Admin/Widgets/Variables", ["name": "foo", "count": "15"])
        ])
        .mapEach { $0.data.getString(at: 0, length: $0.data.readableBytes) }
        .flatMap { items -> EventLoopFuture<View> in
            let widgets = items.compactMap { $0 }
            return req.view.render("System/Admin/Dashboard", ["widgets": widgets])
        }
    }



}
