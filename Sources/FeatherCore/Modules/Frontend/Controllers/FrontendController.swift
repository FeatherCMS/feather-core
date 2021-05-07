//
//  UserFrontendController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

struct FrontendController {
    
    func catchAllView(req: Request) throws -> EventLoopFuture<Response> {
        guard req.method == .GET || !Application.Config.installed else {
            return req.eventLoop.future(error: Abort(.notFound))
        }
        let futures: [EventLoopFuture<Response?>] = req.invokeAll(.response)
        return req.eventLoop.findFirstValue(futures).unwrap(or: Abort(.notFound))
    }

    func sitemap(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "Frontend/Sitemap")
    }
    
    func rss(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "Frontend/Rss") { $0.filter(\.$feedItem == true) }
    }

    func robots(_ req: Request) throws -> EventLoopFuture<Response> {
        req.view.render("Frontend/Robots", ["baseUrl": Application.baseUrl])
            .encodeResponse(status: .ok, headers: ["Content-Type": "text/plain; charset=utf-8"], for: req)
    }

    // MARK: - private
    
    private func variable(_ req: Request, _ key: String) -> EventLoopFuture<String?> {
        CommonVariableModel.query(on: req.db).filter(\.$key == "site" + key.uppercasedFirst).first().map { $0?.value }
    }
    
    /// a helper method to render sitemap and rss feed
    private func renderContentList(_ req: Request,
                                   using template: String,
                                   filter: ((QueryBuilder<FrontendMetadataModel>) -> QueryBuilder<FrontendMetadataModel>)? = nil)
        -> EventLoopFuture<Response>
    {
        var qb = FrontendMetadataModel.query(on: req.db)
        .filter(\.$status == .published)
        .filter(\.$date <= Date())
        if let filter = filter {
            qb = filter(qb)
        }
        return qb.all().mapEach { $0.metadata.encodeToTemplateData() }
            .and(variable(req, "title"))
            .and(variable(req, "excerpt"))
            .flatMap { result -> EventLoopFuture<View> in
                req.tau.render(template: template, context: [
                    "title": .string(result.0.1),
                    "description": .string(result.1),
                    "list": .array(result.0.0),
                    "locale": .string(Application.Config.locale.identifier),
                    "timezone": .string(Application.Config.timezone.identifier),
                    "baseUrl": .string(Application.baseUrl),
                ])
            }
            .encodeResponse(status: .ok, headers: ["Content-Type": "text/xml; charset=utf-8"], for: req)
    }
    
}
