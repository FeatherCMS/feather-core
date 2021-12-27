//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import SwiftHtml

public struct SystemInstallErrorPageTemplate: TemplateRepresentable {
    
    var context: AdminErrorContext
    
    public init(_ context: AdminErrorContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: context.title)) {
            Span("⚠️")
                .class("icon")
            H1(context.title)
            P(context.message)
            A("Home →")
                .href("/")
        }
        .render(req)
    }
}
