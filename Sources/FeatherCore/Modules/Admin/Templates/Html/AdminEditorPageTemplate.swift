//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

struct AdminEditorPageTemplate: TemplateRepresentable {

    var context: AdminEditorPageContext

    init(_ context: AdminEditorPageContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                Div {
                    H1(context.title)
                    context.links.compactMap { $0.render(req) }
                }
                .class("lead")
               
                FormTemplate(context.form).render(req)

                Section {
                    context.actions.compactMap { $0.render(req) }
                }
            }
            .class("container")
        }
        .render(req)
    }
}


