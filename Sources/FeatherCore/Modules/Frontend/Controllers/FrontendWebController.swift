//
//  UserFrontendController.swift
//  UserModule
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

struct FrontendWebController {

    // MARK: - private
    
    func catchAllView(req: Request) throws -> EventLoopFuture<Response> {
        let futures: [EventLoopFuture<Response?>] = req.invokeAll("response")
        return req.eventLoop.findFirstValue(futures).unwrap(or: Abort(.notFound))
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
        return qb.all().mapEach { $0.metadata }.flatMap { req.view.render(template, ["list": $0]) }
            .encodeResponse(status: .ok, headers: ["Content-Type": "text/xml; charset=utf-8"], for: req)
    }

    func sitemap(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "System/Sitemap")
    }
    
    func rss(_ req: Request) throws -> EventLoopFuture<Response> {
        renderContentList(req, using: "System/Rss") { $0.filter(\.$feedItem == true) }
    }

    func robots(_ req: Request) throws -> EventLoopFuture<Response> {
        req.view.render("System/Robots").encodeResponse(status: .ok, headers: ["Content-Type": "text/plain; charset=utf-8"], for: req)
    }
    
}
