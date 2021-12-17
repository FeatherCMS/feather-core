//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import Vapor
import SwiftHtml

public struct WebWelcomeTemplate: TemplateRepresentable {
    
    public struct Context {
        public var index: WebIndexTemplate.Context
        
        public var title: String
        public var message: String
        
        public init(index: WebIndexTemplate.Context, title: String, message: String) {
            self.index = index
            self.title = title
            self.message = message
        }
    }

    unowned var req: Request
    var context: Context
    
    public init(_ req: Request, context: Context) {
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
