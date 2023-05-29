//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct MultipleFileFieldTemplate: TemplateRepresentable {

    public var context: MultipleFileFieldContext
    
    public init(_ context: MultipleFileFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        LabelTemplate(context.label).render(req)

        Input()
            .type(.file)
            .multiple()
            .key(context.key + "[]")
            .accept(context.accept)
            .class("field")
        if let error = context.error {
            Span(error)
                .class("error")
        }
    }
}
