//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 25..
//

struct UserInstallStepController: SystemInstallStepController {

    private func render(_ req: Request, form: AbstractForm) -> Response {
        let template = UserInstallStepTemplate(.init(form: form.context(req)))
        return req.templates.renderHtml(template)
    }

    func installStep(_ req: Request, info: SystemInstallInfo) async throws -> Response {
        let form = UserInstallForm()
        try await form.load(req: req)
        try await form.read(req: req)
        return render(req, form: form)
    }

    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? {
        let form = UserInstallForm()
        try await form.load(req: req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return render(req, form: form)
        }
        try await form.write(req: req)
        
        try await UserAccountModel(email: form.email,
                                   password: try! Bcrypt.hash(form.password),
                                   isRoot: true)
            .create(on: req.db)
        
        try await continueInstall(req, with: info.nextStep)
        return req.redirect(to: installPath(req, for: info.nextStep))
    }
}
