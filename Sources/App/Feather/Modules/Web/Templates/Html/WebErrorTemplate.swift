//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import SwiftHtml

struct WebErrorTemplate: TemplateRepresentable {
    
    struct Context {
        var index: WebIndexTemplate.Context
        
        var title: String
        var message: String
    }

    // MARK: - context
    
    unowned var req: Request
    var context: Context
    
    init(_ req: Request, context: Context) {
        self.req = req
        self.context = context
    }

    // MARK: - view
    
    var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            Span("⚠️")
                .class("icon")
            H1(context.title)
            P(context.message)
            A("Home →")
                .href("/")
        }.tag
    }
}
