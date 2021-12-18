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
                Div {
                    H1(context.title)
                    for item in context.links {
                        if req.checkPermission(item.permission) {
                            A(item.label)
                                .href(item.url)
                                .target(.blank, item.isBlank)
                                .class(item.style)
                        }
                    }
                }
                .class("lead")
               
                FormTemplate(req, context.form).tag

                Section {
                    for item in context.actions {
                        if req.checkPermission(item.permission) {
                            A(item.label)
                                .href(item.url)
                                .class(item.style)
                        }
                    }
                }
            }
            .class("container")
        }.tag
    }
}


