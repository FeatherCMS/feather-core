//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor

struct UserAuthController {

    // MARK: - private
    
    private func render(_ req: Request, form: UserLoginForm) -> Response {
        let formTpl = form.render(req: req)
        let template = UserLoginTemplate(req, context: .init("Sign in", message: "sign in"), form: formTpl)
        return req.html.render(template)
    }

    private func getCustomRedirect(_ req: Request) -> String {
        if let customRedirect: String = req.query[Feather.config.paths.redirectQueryKey], !customRedirect.isEmpty {
            return customRedirect.safePath()
        }
        return "/"
    }
    
    // MARK: - api

    func loginView(_ req: Request) async throws -> Response {
        guard req.auth.has(UserAccount.self) else {
            let form = UserLoginForm()
            await form.load(req: req)
            return render(req, form: form)
        }
        return req.redirect(to: getCustomRedirect(req), type: .normal)
    }

    func login(_ req: Request) async throws -> Response {
        /// user is logged in, credentials were correct
        if let user = req.auth.get(UserAccount.self) {
            req.session.authenticate(user)
            return req.redirect(to: getCustomRedirect(req))
        }

        let form = UserLoginForm()
        await form.load(req: req)
        await form.process(req: req)
        _ = await form.validate(req: req)
        form.error = "Invalid email or password"
        return render(req, form: form)
    }

    func logout(_ req: Request) throws -> Response {
        req.auth.logout(UserAccount.self)
        req.session.unauthenticate(UserAccount.self)
        return req.redirect(to: getCustomRedirect(req))
    }
}
