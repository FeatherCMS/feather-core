//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

struct FrontendAdminController {
    
    // MARK: - settings
    
    private func render(req: Request, form: Form) -> EventLoopFuture<View> {
        req.view.render("Frontend/Admin/Settings", ["form": form])
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
