//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

struct AdminEditorPageTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: AdminEditorPageContext

    init(_ req: Request, _ context: AdminEditorPageContext) {
        self.req = req
        self.context = context
    }

    @TagBuilder
    var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Div {
                H1(context.title)

                FormTemplate(req, context.form).tag

                Section {
                    //TODO: check permission
                    A("Delete")
                        .href(req.url.path)
                        .class("destructive")
                }
            }
        }.tag
    }
}


