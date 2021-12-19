//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebFrontendController {
    
    func renderWelcomeTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomePageTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }
    
    func renderSitemapTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomePageTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }

    func renderRssTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomePageTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }

    func renderRobotsTemplate(_ req: Request) async throws -> Response {
        let robots = """
            Sitemap: #(baseUrl)\(Feather.config.paths.sitemap.safePath())

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
