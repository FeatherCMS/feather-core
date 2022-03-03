//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

struct SystemAdminEditorPageTemplate: TemplateRepresentable {

    var context: SystemAdminEditorPageContext

    init(_ context: SystemAdminEditorPageContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: context.title, links: context.navigation)).render(req)
                   
                    FormTemplate(context.form).render(req)

                    Section {
                        Nav {
                            context.actions.map { LinkTemplate($0).render(req) }
                        }
                    }
                }
            }
        }
        .render(req)
    }
}


