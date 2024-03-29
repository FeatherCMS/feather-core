//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

public struct CheckboxFieldTemplate: TemplateRepresentable {

    public var context: CheckboxFieldContext
    
    public init(_ context: CheckboxFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)
        
        if context.options.isEmpty {
            Label {
                Span("No available options")
                    .class("more")
            }
        }
        else {
            for item in context.options {
                Input()
                    .type(.checkbox)
                    .name(context.key + "[]")
                    .value(item.key)
                    .id(context.key + "-" + item.key)
                    .checked(context.values.contains(item.key))
                Label(item.label)
                    .for(context.key + "-" + item.key)
                Br()
            }
        }

        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
