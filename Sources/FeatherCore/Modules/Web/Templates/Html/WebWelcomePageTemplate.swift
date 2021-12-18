//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

public struct WebWelcomePageTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: WebWelcomePageContext
    
    public init(_ req: Request, context: WebWelcomePageContext) {
        self.req = req
        self.context = context
    }
    
    public var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            H1(context.title)
            P(context.message)

            Span(req.variable("test") ?? "nope")
            Span(req.variable("asdfas") ?? "nope")
        }.tag
    }
}
