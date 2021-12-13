//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import SwiftHtml

public struct AdminErrorTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: AdminErrorContext
    
    public init(_ req: Request, _ context: AdminErrorContext) {
        self.req = req
        self.context = context
    }
    
    public var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title, breadcrumbs: [])) {
            Span("⚠️")
                .class("icon")
            H1(context.title)
            P(context.message)
            A("Home →")
                .href("/")
        }.tag
    }
}
