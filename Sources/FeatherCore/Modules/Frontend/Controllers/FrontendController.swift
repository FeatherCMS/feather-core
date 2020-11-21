//
//  FrontendController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//


struct FrontendController {
    
    func catchAllView(req: Request) throws -> EventLoopFuture<Response> {
        let futures: [EventLoopFuture<Response?>] = req.invokeAll("frontend-page")
        return req.eventLoop.first(futures).unwrap(or: Abort(.notFound))
    }

    // MARK: - sitemap, rss

    private func renderContentList(_ req: Request,
                                   using template: String,
                                   filter: ((QueryBuilder<Metadata>) -> QueryBuilder<Metadata>)? = nil)
        -> EventLoopFuture<Response>
    {
        var qb = Metadata.query(on: req.db)
        .filter(\.$status == .published)
        if let filter = filter {
            qb = filter(qb)
        }
        return qb.all()
        .mapEach(\.leafData)
        .flatMap { req.leaf.render(template: template, context: ["list": .array($0)]) }
        .encodeResponse(status: .ok, headers: ["Content-Type": "text/xml; charset=utf-8"], for: req)
    }

    func sitemap(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "Frontend/Sitemap")
    }
    
    func rss(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "Frontend/Rss") { $0.filter(\.$feedItem == true) }
    }
}
