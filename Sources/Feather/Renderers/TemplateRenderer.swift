//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml
import Vapor

public struct TemplateRenderer {
    
    var req: Request

    public init(_ req: Request) {
        self.req = req
    }
    
    public func renderHtml(_ template: TemplateRepresentable,
                           minify: Bool = true,
                           indent: Int = 4,
                           status: HTTPStatus = .ok) -> Response {

        let root = template.render(req)
        let doc = Document(.html) { root }
        let html = DocumentRenderer(minify: minify, indent: indent).render(doc)
        return Response(status: status,
                        headers: [
//                            "Link": "</css/web/style.css>; rel=preload; as=style",
                            "content-type": "text/html",
                        ],
                        body: .init(string: html))
    }
    
    public func renderXml(_ template: TemplateRepresentable,
                          minify: Bool = true,
                          indent: Int = 4) -> Response {
        let root = template.render(req)
        let doc = Document(.xml) { root }
        let xml = DocumentRenderer(minify: minify, indent: indent).render(doc)
        return Response(status: .ok,
                        headers: [
                            "content-type": "application/xml",
                        ],
                        body: .init(string: xml))
    }
}

public extension Request {
    var templates: TemplateRenderer { .init(self) }
}
