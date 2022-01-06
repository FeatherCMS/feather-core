//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

struct UserAuthController {

    // MARK: - private
    
    private func render(_ req: Request, form: UserLoginForm) -> Response {
        let formTpl = form.render(req: req)
        let template = UserLoginTemplate(.init("Sign in", message: "sign in"), form: formTpl)
        return req.templates.renderHtml(template)
    }

    private func getCustomRedirect(_ req: Request) -> String {
        if let customRedirect: String = req.query[Feather.config.paths.redirectQueryKey], !customRedirect.isEmpty {
            return customRedirect.safePath()
        }
        return "/"
    }
    
    // MARK: - api

    func loginView(_ req: Request) async throws -> Response {
        guard req.auth.has(FeatherAccount.self) else {
            let form = UserLoginForm()
            try await form.load(req: req)
            return render(req, form: form)
        }
        return req.redirect(to: getCustomRedirect(req), type: .normal)
    }

    func login(_ req: Request) async throws -> Response {
        /// user is logged in, credentials were correct
        if let user = req.auth.get(FeatherAccount.self) {
            req.session.authenticate(user)
            return req.redirect(to: getCustomRedirect(req))
        }

        let form = UserLoginForm()
        try await form.load(req: req)
        try await form.process(req: req)
        _ = try await form.validate(req: req)
        form.error = "Invalid email or password"
        return render(req, form: form)
    }
    
    func loginApi(req: Request) async throws -> FeatherToken {
        guard let user = req.auth.get(FeatherAccount.self) else {
            throw Abort(.unauthorized)
        }
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789="
        let tokenValue = String((0..<64).map { _ in letters.randomElement()! })
//        let tokenValue = [UInt8].random(count: 32).base64
        let token = UserTokenModel(value: tokenValue, userId: user.id)
        try await token.create(on: req.db)
        return FeatherToken(id: token.uuid, value: token.value, user: user)
    }

    func logout(_ req: Request) async throws -> Response {
        req.auth.logout(FeatherAccount.self)
        req.session.unauthenticate(FeatherAccount.self)
        return req.redirect(to: getCustomRedirect(req))
    }
}
