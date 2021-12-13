//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct SelectFieldTemplate: TemplateRepresentable {

    var context: SelectFieldContext
    
    public init(_ context: SelectFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public var tag: Tag {
        LabelTemplate(context.label).tag
        
        Select {
            for item in context.options {
                Option(item.label)
                    .value(item.key)
                    .selected(context.value == item.key)
            }
        }
        .name(context.key)
        
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
