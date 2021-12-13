//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct HiddenFieldTemplate: TemplateRepresentable {

    var context: HiddenFieldContext
    
    public init(_ context: HiddenFieldContext) {
        self.context = context
    }

    public var tag: Tag {
        Input()
            .type(.hidden)
            .name(context.key)
            .value(context.value ?? "")
    }
}
