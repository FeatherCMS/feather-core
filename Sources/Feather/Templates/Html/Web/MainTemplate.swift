//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 25..
//

import Vapor
import SwiftHtml

public struct MainTemplate: TemplateRepresentable {
    
    public let context: MainContext
    
    public init(_ context: MainContext) {
        self.context = context
    }

    public func render(_ req: Request) -> Tag {
        Main {
            Div {
                context.body
            }
            .class("safe-area")
        }
    }
}
