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
            "menus": menus
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
    
    // MARK: - settings
    
    private func render(req: Request, form: Form) -> EventLoopFuture<View> {
        req.view.render("System/Admin/Settings", ["form": form])
    }

    func settingsView(req: Request) throws -> EventLoopFuture<View> {
        let form = SystemSettingsForm()
        return form.load(req: req)
            .flatMap { form.read(req: req) }
            .flatMap { render(req: req, form: form) }
    }
    
    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
        let form = SystemSettingsForm()
        return form.load(req: req)
            .flatMap { form.process(req: req) }
            .flatMap { form.validate(req: req) }
            .throwingFlatMap { isValid in
                guard isValid else {
                    return render(req: req, form: form).encodeResponse(for: req)
                }
                return form.write(req: req)
                    .flatMap { form.save(req: req) }
                    .map { req.redirect(to: req.url.path.safePath()) }
            }
    }
    
}
