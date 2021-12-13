//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct ToggleFieldTemplate: TemplateRepresentable {

    var context: ToggleFieldContext
    
    public init(_ context: ToggleFieldContext) {
        self.context = context
    }

    @TagBuilder
    public var tag: Tag {
        LabelTemplate(context.label).tag

        Input()
            .type(.checkbox)
            .key(context.key)
            .checked(context.value)

        if let error = context.error {
            Span(error)
                .class("error")
        }

    }
}
