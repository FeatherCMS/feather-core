//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

import SwiftHtml

public struct SystemInstallPageTemplate: TemplateRepresentable {
    
    var context: WebInstallPageContext
    
    public init(_ context: WebInstallPageContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: context.title)) {
            Span(context.icon)
                .class("icon")
            H1(context.title)
            P(context.message)
            A(context.link.label)
                .href(context.link.path)
        }
        .render(req)
    }
}
