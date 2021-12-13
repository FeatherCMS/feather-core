//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import SwiftHtml

public struct WebInstallErrorTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: AdminErrorContext
    
    public init(_ req: Request, _ context: AdminErrorContext) {
        self.req = req
        self.context = context
    }
    
    public var tag: Tag {
        WebIndexTemplate.init(req, context: .init(title: context.title)) {
            Span("⚠️")
                .class("icon")
            H1(context.title)
            P(context.message)
            A("Home →")
                .href("/")
        }.tag
    }
}
