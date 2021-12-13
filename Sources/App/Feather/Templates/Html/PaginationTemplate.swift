//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

public struct PaginationTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: PaginationContext
    
    public init(_ req: Request, _ context: PaginationContext) {
        self.req = req
        self.context = context
    }
    
    @TagBuilder
    public var tag: Tag {
        if context.total > 1 && context.current <= context.total {
            Hr()
            
            Div {
                if context.current > 1 {
                    A("«")
                        .href(req.buildQuery(["page": 1]))
                }
                else {
                    Text("«")
                }
                
                if context.current > 1 {
                    A("‹")
                        .href(req.buildQuery(["page": context.current - 1]))
                }
                else {
                    Text("‹")
                }
                
                Span("Page \(context.current) of \(context.total)")
                
                if context.current < context.total {
                    A("›")
                        .href(req.buildQuery(["page": context.current + 1]))
                }
                else {
                    Text("›")
                }
                
                if context.current < context.total {
                    A("»")
                        .href(req.buildQuery(["page": context.total]))
                }
                else {
                    Text("»")
                }
            }
            .id("pagination")
            .class("center")
        }
    }
}


