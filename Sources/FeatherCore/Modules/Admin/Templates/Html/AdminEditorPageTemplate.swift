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
                    LeadTemplate(.init(title: context.title, links: context.navigation)).render(req)
                   
                    FormTemplate(context.form).render(req)

                    Section {
                        Nav {
                            context.actions.map { LinkTemplate($0).render(req) }
                        }
                    }
                }
                .class("container")
            }
            .class("wrapper")
        }
        .render(req)
    }
}


