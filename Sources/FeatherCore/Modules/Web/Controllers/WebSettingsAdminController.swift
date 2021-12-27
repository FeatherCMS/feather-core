//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

struct WebSettingsAdminController {

    private func render(_ req: Request, form: FeatherForm) -> Response {
        let template = WebSettingsPageTemplate(.init(form: form.context(req)))
        return req.templates.renderHtml(template)
    }

    func settingsView(_ req: Request) async throws -> Response {
        let form = WebSettingsForm()
        try await form.load(req: req)
        try await form.read(req: req)
        return render(req, form: form)
    }

    func settings(_ req: Request) async throws -> Response {
        let form = WebSettingsForm()
        try await form.load(req: req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return render(req, form: form)
        }
        try await form.write(req: req)
        return req.redirect(to: req.url.path)
    }

}
