//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct SubmitFieldTemplate: TemplateRepresentable {

    public var context: SubmitFieldContext
    
    public init(_ context: SubmitFieldContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        Input()
            .type(.submit)
            .value(context.value)
    }
}
