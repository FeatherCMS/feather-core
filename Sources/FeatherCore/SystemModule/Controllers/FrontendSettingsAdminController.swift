//
//  SiteAdminontroller.swift
//  FrontendModule
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//



//struct FrontendSiteAdminController {
//
//    func settingsView(req: Request) throws -> EventLoopFuture<View> {
//        let form = SystemSettingsForm()
//        return form.initialize(req: req).flatMap {
//            render(req: req, form: form)
//        }
//    }
//
//    func render(req: Request, form: SystemSettingsForm) -> EventLoopFuture<View> {
//        let formId = UUID().uuidString
//        let nonce = req.generateNonce(for: "site-settings-form", id: formId)
// 
//        return req.tau.render(template: "System/Admin/Settings", context: [
//            "formId": .string(formId),
//            "formToken": .string(nonce),
//            "fields": form.fieldsTemplateData,
//            "notification": .string(form.notification)
//        ])
//    }
//    
//    func updateSettings(req: Request) throws -> EventLoopFuture<Response> {
//        try req.validateFormToken(for: "site-settings-form")
//
//        let form = SystemSettingsForm()
//        return form.initialize(req: req)
//            .flatMap { form.process(req: req) }
//            .flatMap { form.validate(req: req) }
//            .flatMap { [self] isValid -> EventLoopFuture<View> in
//                guard isValid else {
//                    return render(req: req, form: form)
//                }
//                return form.save(req: req).flatMap {
//                    render(req: req, form: form)
//                }
//            }
//            .encodeResponse(for: req)
//    }
//
//}
