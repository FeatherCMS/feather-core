//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

public struct HtmlRenderer {
    
    public func render(_ template: TemplateRepresentable, minify: Bool = false, indent: Int = 4) -> Response {
        let doc = Document(.html) { template.tag }
        return Response(status: .ok,
                 headers: ["content-type": "text/html"],
                 body: .init(string: DocumentRenderer(minify: minify, indent: indent).render(doc)))
    }
}

public extension Request {
    var html: HtmlRenderer { .init() }
}
