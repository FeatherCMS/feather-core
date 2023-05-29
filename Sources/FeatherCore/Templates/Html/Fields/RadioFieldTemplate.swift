//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct RadioFieldTemplate: TemplateRepresentable {

    public var context: RadioFieldContext
    
    public init(_ context: RadioFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)

        for item in context.options {
            Input()
                .type(.radio)
                .name(item.key)
                .id(context.key + "-" + item.key)
                .value(item.key)
                .checked(context.value == item.key)
            Label(item.label)
                .for(context.key + "-" + item.key)
            Br()
        }
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
