//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

struct WebFrontendController {
    
    func renderWelcomeTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomeTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }
    
    func renderSitemapTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomeTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }
    
    func renderRssTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomeTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }
    
    func renderRobotsTemplate(_ req: Request) async throws -> Response {
        let template = WebWelcomeTemplate(req, context: .init(index: .init(title: "title"),
                                                              title: "Hello, World!",
                                                              message: "Lorem ipsum dolor sit amet"))
        return req.html.render(template)
    }
}
