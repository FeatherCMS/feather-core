//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 09..
//

import SwiftHtml

struct BreadcrumbContext {
    let links: [LinkContext]
}

struct BreadcrumbTemplate: TemplateRepresentable {
    
    let context: BreadcrumbContext
    
    init(_ context: BreadcrumbContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Div {
            Nav {
                context.links.map { LinkTemplate($0).render(req) }
            }
        }
        .id("breadcrumb")
        .class("noselect")
    }
}
