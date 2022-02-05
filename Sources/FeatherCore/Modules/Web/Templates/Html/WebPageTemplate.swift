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
        WebIndexTemplate(.init(title: context.page.title, metadata: context.page.metadata)) {
            Wrapper {
                Container {
                    H1(context.page.title)
                    Text(context.page.content)
                }
                .class("\(context.page.metadata.slug)-page", !context.page.metadata.slug.isEmpty)
            }
            .id("web-page")
        }
        .render(req)
    }
}
