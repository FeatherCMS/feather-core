//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import FeatherCoreApi

#warning("place these somewhere else")
extension UserToken: Content {}
extension UserAccount: Content {}
extension UserRole: Content {}
extension UserPermission: Content {}

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
            try await form.load(req: req)
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
        try await form.load(req: req)
        try await form.process(req: req)
        _ = try await form.validate(req: req)
        form.error = "Invalid email or password"
        return render(req, form: form)
    }
    
    func loginApi(req: Request) async throws -> UserToken {
        guard let user = req.auth.get(UserAccount.self) else {
            throw Abort(.unauthorized)
        }
        let tokenValue = [UInt8].random(count: 16).base64
        let token = UserTokenModel(value: tokenValue, userId: user.id)
        try await token.create(on: req.db)
        return UserToken(id: token.uuid, value: token.value, user: user)
    }

    func logout(_ req: Request) async throws -> Response {
        req.auth.logout(UserAccount.self)
        req.session.unauthenticate(UserAccount.self)
        return req.redirect(to: getCustomRedirect(req))
    }
}
