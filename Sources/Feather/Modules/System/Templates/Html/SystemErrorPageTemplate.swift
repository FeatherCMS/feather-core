//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 28..
//


import Vapor
import SwiftHtml

struct SystemErrorPageTemplate: TemplateRepresentable {
    
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
