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
                    context.links.compactMap { $0.render(req) }
                }
                .class("lead")
               
                Dl {
                    for field in context.fields {
                        if let value = field.value {
                            Dt(field.label)
                            switch field.type {
                            case .text:
                                value.isEmpty ? Dd("&nbsp;") : Dd(value.replacingOccurrences(of: "\n", with: "<br>"))
                            case .image:
                                Dd {
                                    Img(src: req.fs.resolve(key: value), alt: field.label)
                                }
                            }
                        }
                    }
                }

                Section {
                    context.actions.compactMap { $0.render(req) }
                }
            }
            .class("container")
        }.tag
    }
}


