//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor
import SwiftHtml

public struct WebErrorPageTemplate: TemplateRepresentable {

    unowned var req: Request
    public var context: WebErrorPageContext
    
    public init(_ req: Request, context: WebErrorPageContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            Div {
                Span("⚠️")
                    .class("icon")
                H1(context.title)
                P(context.message)
                A("Home →")
                    .href("/")
            }
        }.tag
    }
}
