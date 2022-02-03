//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 15..
//

import SwiftHtml

public struct WebWelcomePageTemplate: TemplateRepresentable {

    var context: WebWelcomePageContext
    
    public init(_ context: WebWelcomePageContext) {        
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        WebIndexTemplate(context.index) {
            Div {
                Div {
                    H1(context.title)
                    P(context.message)
                }
                .class("container", "welcome-page")
            }
            .id("welcome-page")
            .class("wrapper")
        }
        .render(req)
    }
}
