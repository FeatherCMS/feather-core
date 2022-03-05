//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct TextareaFieldTemplate: TemplateRepresentable {
    
    public var context: TextareaFieldContext
    
    public init(_ context: TextareaFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)
        
        Textarea(context.value)
            .name(context.key)
            .placeholder(context.placeholder)
            .class(context.size.rawValue)
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
