//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct AdminDeletePageTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: AdminDeletePageContext

    public init(_ req: Request, _ context: AdminDeletePageContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                Span("🗑")
                    .class("icon")
                H1(context.title)
                P("You are about to permanently delete the<br>`\(context.name)` \(context.type).")
                
                FormTemplate(req, context.form).tag

                A("Cancel")
                    .href(req.getQuery("cancel") ?? context.title)
                    .class(["button", "cancel"])
            }
            .class(["lead", "container", "center"])
        }.tag
    }
}


