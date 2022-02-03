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
    
    private var excerpt: String {
        "You are about to permanently delete the<br>`\(context.name)` \(context.type.lowercased())."
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                Div {
                    LeadTemplate(.init(title: context.title, excerpt: excerpt)) .render(req)

                    FormTemplate(context.form).render(req)

                    A("Cancel")
                        .href(req.getQuery("cancel") ?? "#")
                }
                .class("container")
            }
            .id("delete-confirmation")
            .class("wrapper")
        }
        .render(req)
    }
}


