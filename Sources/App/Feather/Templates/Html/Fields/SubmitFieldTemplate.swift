//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct SubmitFieldTemplate: TemplateRepresentable {

    var context: SubmitFieldContext
    
    public init(_ context: SubmitFieldContext) {
        self.context = context
    }
    
    public var tag: Tag {
        Input()
            .type(.submit)
            .value(context.value)
    }
}
