//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 26..
//

import Vapor
import SwiftHtml

public struct InputFieldTemplate: TemplateRepresentable {

    public var context: InputFieldContext
    
    public init(_ context: InputFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public var tag: Tag {
        LabelTemplate(context.label).tag

        Input()
            .type(context.type)
            .id(context.key)
            .name(context.key)
            .placeholder(context.placeholder)
            .value(context.value ?? "")
            .class("field")
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
