//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 09..
//

import SwiftHtml

public struct BreadcrumbTemplate: TemplateRepresentable {
    
    public let context: BreadcrumbContext
    
    public init(_ context: BreadcrumbContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Div {
            Nav {
                context.links.map { LinkTemplate($0).render(req) }
            }
        }
        .id("breadcrumb")
        .class("noselect")
    }
}
