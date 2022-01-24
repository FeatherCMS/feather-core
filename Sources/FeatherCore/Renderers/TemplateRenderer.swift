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
    
    public func renderHtml(_ template: TemplateRepresentable, minify: Bool = true, indent: Int = 4, status: HTTPStatus = .ok) -> Response {
        let doc = Document(.html) { template.render(req) }
        let html = DocumentRenderer(minify: minify, indent: indent).render(doc)
        return Response(status: status,
                        headers: ["content-type": "text/html"],
                        body: .init(string: html))
    }
    
    public func renderXml(_ template: TemplateRepresentable, minify: Bool = true, indent: Int = 4) -> Response {
        let doc = Document(.xml) { template.render(req) }
        let xml = DocumentRenderer(minify: minify, indent: indent).render(doc)
        return Response(status: .ok,
                        headers: ["content-type": "application/xml"],
                        body: .init(string: xml))
    }
}

public extension Request {
    var templates: TemplateRenderer { .init(self) }
}
