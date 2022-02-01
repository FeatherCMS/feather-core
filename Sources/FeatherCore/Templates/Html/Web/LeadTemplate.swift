//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml



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
            P(context.excerpt)
        }
        .class("lead")
    }
}
