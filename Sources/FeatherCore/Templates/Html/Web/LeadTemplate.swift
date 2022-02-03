//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml
import Darwin

struct LeadTemplate: TemplateRepresentable {
    
    let context: LeadContext
    
    init(_ context: LeadContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        Div {
            if let icon = context.icon {
                Img(src: "svg/\(icon).svg", alt: icon)
            }
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
