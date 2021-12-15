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
    public var tag: Tag {
        LabelTemplate(context.label).tag
        
        Textarea(context.value ?? "")
            .name(context.key)
            .class(context.size.rawValue)
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
