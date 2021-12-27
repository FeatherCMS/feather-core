//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

public struct MultiselectFieldTemplate: TemplateRepresentable {

    var context: MultiselectFieldContext
    
    public init(_ context: MultiselectFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)

        Select {
            for item in context.options {
                Option(item.label)
                    .value(item.key)
                    .selected(context.values.contains(item.key))
            }
        }
        .name(context.key)
        .multiple()

        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
