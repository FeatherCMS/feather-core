//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

import Vapor
import SwiftHtml

public struct WebInstallPageTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: WebInstallPageContext
    
    public init(_ req: Request, _ context: WebInstallPageContext) {
        self.req = req
        self.context = context
    }
    
    public var tag: Tag {
        WebIndexTemplate.init(req, context: .init(title: context.title)) {
            Span(context.icon)
                .class("icon")
            H1(context.title)
            P(context.message)
            A(context.link.label)
                .href(context.link.url)
        }.tag
    }
}
