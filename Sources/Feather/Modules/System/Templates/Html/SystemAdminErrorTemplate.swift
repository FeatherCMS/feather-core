//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import Vapor
import SwiftHtml

struct SystemAdminErrorTemplate: TemplateRepresentable {
    
    var context: SystemAdminErrorContext
    
    init(_ context: SystemAdminErrorContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title)) {
            Wrapper {
                Container {
                    Span("⚠️")
                        .class("icon")
                    H1(context.title)
                    P(context.message)
                    A("Dashboard →")
                        .href("/admin/")
                }
            }
        }
        .render(req)
    }
}
