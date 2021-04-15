//
//  UserFrontendController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

struct SystemFrontendController {

    // MARK: - private
    
    func catchAllView(req: Request) throws -> EventLoopFuture<Response> {
        let futures: [EventLoopFuture<Response?>] = req.invokeAll("response")
        return req.eventLoop.findFirstValue(futures).unwrap(or: Abort(.notFound))
    }

    /// a helper method to render sitemap and rss feed
    private func renderContentList(_ req: Request,
                                   using template: String,
                                   filter: ((QueryBuilder<SystemMetadataModel>) -> QueryBuilder<SystemMetadataModel>)? = nil)
        -> EventLoopFuture<Response>
    {
        var qb = SystemMetadataModel.query(on: req.db)
        .filter(\.$status == .published)
        .filter(\.$date <= Date())
        if let filter = filter {
            qb = filter(qb)
        }
        return qb.all()
        .mapEach { $0.encodeToTemplateData() }
        .flatMap { req.tau.render(template: template, context: ["list": .array($0)]) }
        .encodeResponse(status: .ok, headers: ["Content-Type": "text/xml; charset=utf-8"], for: req)
    }

    func sitemap(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "System/Sitemap")
    }
    
    func rss(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "System/Rss") { $0.filter(\.$feedItem == true) }
    }

    func robots(_ req: Request) throws -> EventLoopFuture<Response> {
        req.tau.render(template: "System/Robots")
            .encodeResponse(status: .ok, headers: ["Content-Type": "text/plain; charset=utf-8"], for: req)
    }
    
    func createContext(req: Request, formId: String, formToken: String) -> FormView {
        .init(id: formId,
              token: formToken,
              title: "",
              key: "",
              modelId: "",
              list: .init(label: "", url: ""),
              nav: [],
              notification: nil)
    }
    
    private func render(req: Request, model: SystemUserModel? = nil, form: SystemLoginForm = .init()) -> EventLoopFuture<Response> {
        if let model = model {
            form.email.output.value = model.email
        }

        var ctx = createContext(req: req, formId: "", formToken: "").encodeToTemplateData().dictionary!
        ctx["fields"] = form.templateData.dictionary!["fields"]

        return req.tau.render(template: "System/Login", context: ["form": .dictionary(ctx)])
            .encodeResponse(for: req)
    }

    private func getCustomRedirect(req: Request) -> String {
        if let customRedirect: String = req.query["redirect"], !customRedirect.isEmpty {
            return customRedirect.safePath()
        }
        return "/"
    }
    
    // MARK: - api
    
    func loginView(req: Request) throws -> EventLoopFuture<Response> {
        guard req.auth.has(SystemUserModel.self) else {
            return render(req: req)
        }
        let response = req.redirect(to: getCustomRedirect(req: req), type: .normal)
        return req.eventLoop.future(response)
    }

    func login(req: Request) throws -> EventLoopFuture<Response> {
        if let user = req.auth.get(SystemUserModel.self) {
            req.session.authenticate(user)
            return req.eventLoop.future(req.redirect(to: getCustomRedirect(req: req)))
        }
        let form = SystemLoginForm()
        return form.initialize(req: req)
            .flatMap { form.process(req: req) }
            .flatMap { form.validate(req: req) }
            .flatMap { _ in
                form.notification = "Invalid username or password"
                return render(req: req, form: form)
            }
    }

    func logout(req: Request) throws -> Response {
        req.auth.logout(SystemUserModel.self)
        req.session.unauthenticate(SystemUserModel.self)
        return req.redirect(to: getCustomRedirect(req: req))
    }
}
