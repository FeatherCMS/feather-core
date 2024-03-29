//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import SwiftHtml

public struct ToggleFieldTemplate: TemplateRepresentable {

    public var context: ToggleFieldContext
    
    public init(_ context: ToggleFieldContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {

        Input()
            .type(.checkbox)
            .key(context.key)
            .value(String(true))
            .checked(context.value)
        
        LabelTemplate(context.label).render(req)

        if let error = context.error {
            Span(error)
                .class("error")
        }

    }
}
