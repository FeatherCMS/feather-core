//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import SwiftHtml

public struct MainTemplate: TemplateRepresentable {
    
    public let context: MainContext
    
    public init(_ context: MainContext) {
        self.context = context
    }
    
    // @TODO: optional wrapper?
    public func render(_ req: Request) -> Tag {
        Main {
            Div {
                Div {
                    context.body
                }
                .class("wrapper")
            }
            .class("safe-area")
        }
    }
}
