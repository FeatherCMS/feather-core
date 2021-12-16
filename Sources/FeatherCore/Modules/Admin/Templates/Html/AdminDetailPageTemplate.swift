//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

struct AdminDetailPageTemplate: TemplateRepresentable {

    unowned var req: Request
    var context: AdminDetailPageContext

    init(_ req: Request, _ context: AdminDetailPageContext) {
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
                                .class(item.style ?? "", item.style != nil)
                        }
                    }
                }
                .class("lead")
               
                Dl {
                    for field in context.fields {
                        // TODO: use proper field type
                        Dt(field.label)
                        if field.value.isEmpty {
                            Dd("&nbsp;")
                        }
                        else {
                            Dd(field.value)
                        }
                    }
                }

                Section {
                    for item in context.actions {
                        if req.checkPermission(item.permission) {
                            A(item.label)
                                .href(item.url)
                                .class(item.style ?? "", item.style != nil)
                        }
                    }
                }
            }
        }.tag
    }
}


