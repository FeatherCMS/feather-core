//
//  SiteAdminontroller.swift
//  SiteModule
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

struct FrontendSiteAdminController {

    func settingsView(req: Request) throws -> EventLoopFuture<View> {
        let form = FrontendSettingsForm()
        return form.initialize(req: req).flatMap {
            render(req: req, form: form)
        }
    }

    func render(req: Request, form: FrontendSettingsForm) -> EventLoopFuture<View> {
        let formId = UUID().uuidString
        let nonce = req.generateNonce(for: "site-settings-form", id: formId)
 
        return req.leaf.render(template: "Frontend/Admin/Settings", context: [
            "formId": .string(formId),
            "formToken": .string(nonce),
            "fields": form.fieldsLeafData,
            "notification": .string(form.notification)
        ])
    }
    
    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
        try req.validateFormToken(for: "site-settings-form")

        let form = FrontendSettingsForm()
        return form.initialize(req: req)
            .throwingFlatMap { try form.processInput(req: req) }
            .flatMap { form.validate(req: req) }
            .flatMap { [self] isValid -> EventLoopFuture<View> in
                guard isValid else {
                    return render(req: req, form: form)
                }
                return form.save(req: req).flatMap { render(req: req, form: form) }
            }
            .encodeResponse(for: req)
    }

}
