//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 06..
//

import Vapor
import SwiftHtml

struct SystemInstallErrorPageTemplate: TemplateRepresentable {
    
    var context: SystemAdminErrorContext
    
    init(_ context: SystemAdminErrorContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: context.title)) {
            Wrapper {
                Container {
                    Span("⚠️")
                        .class("icon")
                    H1(context.title)
                    P(context.message)
                    A("Home →")
                        .href("/")
                }
            }
        }
        .render(req)
    }
}
