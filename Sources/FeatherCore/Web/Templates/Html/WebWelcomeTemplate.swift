//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

struct WebWelcomeTemplate: TemplateRepresentable {
    
    struct Context {
        var index: WebIndexTemplate.Context
        
        var title: String
        var message: String
    }

    unowned var req: Request
    var context: Context
    
    init(_ req: Request, context: Context) {
        self.req = req
        self.context = context
    }
    
    var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            H1(context.title)
            P(context.message)

            Span(req.variable("test") ?? "nope")
            Span(req.variable("asdfas") ?? "nope")
        }.tag
    }
}
