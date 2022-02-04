//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct PaginationTemplate: TemplateRepresentable {
    
    var context: PaginationContext
    
    public init(_ context: PaginationContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        if context.total > 1 && context.current <= context.total {
            Div {
                if context.current > 1 {
                    A("«")
                        .href(req.buildQuery(["page": 1]))
                }
                else {
                    Span("«")
                }
                
                if context.current > 1 {
                    A("‹")
                        .href(req.buildQuery(["page": context.current - 1]))
                }
                else {
                    Span("‹")
                }
                
                Span("Page \(context.current) of \(context.total)")
                
                if context.current < context.total {
                    A("›")
                        .href(req.buildQuery(["page": context.current + 1]))
                }
                else {
                    Span("›")
                }
                
                if context.current < context.total {
                    A("»")
                        .href(req.buildQuery(["page": context.total]))
                }
                else {
                    Span("»")
                }
            }
            .id("pagination")
            .class("center")
        }
    }
}


