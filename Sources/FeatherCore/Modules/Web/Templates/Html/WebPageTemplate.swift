//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

public struct WebPageTemplate: TemplateRepresentable {

    public var context: WebPageContext
    
    public init(_ context: WebPageContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        WebIndexTemplate(context.index) {
            Div {
                H1(context.page.title)
                Text(context.page.content)
            }
            .id("page")
            .class(["container", "\(context.page.metadata.slug)-page"])
        }
        .render(req)
    }
}
