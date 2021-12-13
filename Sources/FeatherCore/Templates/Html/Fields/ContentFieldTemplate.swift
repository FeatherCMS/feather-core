//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct ContentFieldTemplate: TemplateRepresentable {

    var context: ContentFieldContext
    
    public init(_ context: ContentFieldContext) {
        self.context = context
    }

    @TagBuilder
    public var tag: Tag {
        LabelTemplate(context.label).tag
        
        Textarea(context.value ?? "")
            .name(context.key)
            .class("large")
        
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
