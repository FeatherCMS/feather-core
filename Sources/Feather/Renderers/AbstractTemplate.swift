//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 22..
//

import Vapor
import SwiftHtml

open class AbstractTemplate<T>: TemplateRepresentable {
    open var context: T
    
    public init(_ context: T) {
        self.context = context
    }

    open func render(_ req: Request) -> Tag {
        fatalError("Abstract render function")
    }
}

