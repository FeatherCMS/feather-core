//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml
import Darwin

public struct LeadTemplate: TemplateRepresentable {
    
    public let context: LeadContext
    
    public init(_ context: LeadContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Div {
            H1(context.title)
            if let excerpt = context.excerpt {
                P(excerpt)
            }
            if !context.links.isEmpty {
                Nav {
                    context.links.map { LinkTemplate($0).render(req) }
                }
            }
        }
        .class("lead")
    }
}
