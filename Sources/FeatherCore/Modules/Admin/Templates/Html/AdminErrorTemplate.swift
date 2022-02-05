//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 30..
//

import SwiftHtml

public struct AdminErrorTemplate: TemplateRepresentable {
    
    var context: AdminErrorContext
    
    public init(_ context: AdminErrorContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title)) {
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
