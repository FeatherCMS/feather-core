//
//  AdminController.swift
//  AdminModule
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

struct SystemAdminController {

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
    
    func settingsView(req: Request) throws -> EventLoopFuture<View> {
        let form = SystemSettingsForm(fields: [])
        return form.load(req: req).flatMap {
            render(req: req, form: form)
        }
    }

    func render(req: Request, form: SystemSettingsForm) -> EventLoopFuture<View> {
        req.view.render("System/Admin/Settings", ["form": form])
    }
    
    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
        try req.validateFormToken(for: "site-settings-form")

        let form = SystemSettingsForm(fields: [])
        return form.load(req: req)
            .flatMapThrowing { try form.process(req: req) }
            .flatMap { form.validate(req: req) }
            .flatMap { [self] isValid -> EventLoopFuture<View> in
                guard isValid else {
                    return render(req: req, form: form)
                }
                return form.save(req: req).flatMap {
                    render(req: req, form: form)
                }
            }
            .encodeResponse(for: req)
    }
}
