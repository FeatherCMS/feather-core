//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import SwiftHtml

public struct WebErrorPageTemplate: TemplateRepresentable {

    public var context: WebErrorPageContext
    
    public init(_ context: WebErrorPageContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        WebIndexTemplate(context.index) {
            Div {
                Span("⚠️")
                    .class("icon")
                H1(context.title)
                P(context.message)
                A("Home →")
                    .href("/")
            }
        }
        .render(req)
    }
}
