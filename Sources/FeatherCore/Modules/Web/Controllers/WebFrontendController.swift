//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

struct WebFrontendController {
    
    func renderWelcomeTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomePageTemplate(.init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.templates.renderHtml(template)
    }
    
    func renderSitemapTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await WebMetadataModel.findAll(on: req.db)
        let api = WebMetadataApiController()
        let objects = try await metadatas.mapAsync { try await api.listOutput(req, $0) }
        let template = WebSitemapTemplate(.init(items: objects))
        return req.templates.renderXml(template)
    }

    func renderRssTemplate(_ req: Request) async throws -> Response {
        let metadatas = try await WebMetadataModel.findAll(on: req.db) { $0.filter(\.$feedItem == true) }
        let api = WebMetadataApiController()
        let objects = try await metadatas.mapAsync { try await api.listOutput(req, $0) }
        let template = WebRssTemplate(.init(items: objects))
        return req.templates.renderXml(template)
    }

    func renderRobotsTemplate(_ req: Request) async throws -> Response {
        let robots = """
            Sitemap: \(Feather.baseUrl)\(Feather.config.paths.sitemap.safePath())

            User-agent: *
            Disallow: \(Feather.config.paths.admin.safePath())
            Disallow: \(Feather.config.paths.api.safePath())
            """
        return Response(status: .ok,
                        headers: [
                            "content-type": "text/plain"
                        ],
                        body: .init(string: robots))
    }
}
