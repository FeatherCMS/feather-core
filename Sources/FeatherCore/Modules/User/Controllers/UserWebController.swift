//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

struct UserWebController {

    // MARK: - private
    
    private func render(req: Request, form: Form) -> EventLoopFuture<Response> {
        return req.view.render("System/Login", ["form": form]).encodeResponse(for: req)
    }

    private func getCustomRedirect(req: Request) -> String {
        if let customRedirect: String = req.query["redirect"], !customRedirect.isEmpty {
            return customRedirect.safePath()
        }
        return "/"
    }
    
    // MARK: - api
    
    func loginView(req: Request) throws -> EventLoopFuture<Response> {
        guard req.auth.has(User.self) else {
            return render(req: req, form: UserLoginForm())
        }
        let response = req.redirect(to: getCustomRedirect(req: req), type: .normal)
        return req.eventLoop.future(response)
    }

    func login(req: Request) throws -> EventLoopFuture<Response> {
        if let user = req.auth.get(User.self) {
            req.session.authenticate(user)
            return req.eventLoop.future(req.redirect(to: getCustomRedirect(req: req)))
        }
        let form = UserLoginForm()
        return form.load(req: req)
            .flatMap { form.process(req: req) }
            .flatMap { form.validate(req: req) }
            .flatMap { isValid in
                if isValid {
                    form.error = "Invalid username or password"
                }
                return render(req: req, form: form)
            }
    }

    func logout(req: Request) throws -> Response {
        req.auth.logout(User.self)
        req.session.unauthenticate(User.self)
        return req.redirect(to: getCustomRedirect(req: req))
    }
}
