//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import SwiftHtml

struct WebSettingsPageTemplate: TemplateRepresentable {
    
    var context: WebSettingsContext
    
    init(_ context: WebSettingsContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: "Settings", breadcrumbs: [
            LinkContext(label: "Web", dropLast: 1),
        ])) {
            Div {
                Div {
                    LeadTemplate(.init(title: "Settings")).render(req)
                    FormTemplate(context.form).render(req)
                }
                .class("container")
            }
            .class("wrapper")
        }
        .render(req)
    }
}


