//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct LabelTemplate: TemplateRepresentable {

    var context: LabelContext

    public init(_ context: LabelContext) {
        self.context = context
    }

    @TagBuilder
    public var tag: Tag {
        Label(context.title ?? context.key.uppercasedFirst)
            .for(context.key)

        if let more = context.more {
            Span(more)
                .class("more")
        }
        if context.required {
            Span("*")
                .class("required")
        }
    }
}



