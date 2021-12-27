//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

public struct AdminDeletePageTemplate: TemplateRepresentable {

    var context: AdminDeletePageContext

    public init(_ context: AdminDeletePageContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                Span("🗑")
                    .class("icon")
                H1(context.title)
                P("You are about to permanently delete the<br>`\(context.name)` \(context.type).")
                
                FormTemplate(context.form).render(req)

                A("Cancel")
                    .href(req.getQuery("cancel") ?? "#")
                    .class(["button", "cancel"])
            }
            .class(["lead", "container", "center"])
        }
        .render(req)
    }
}


