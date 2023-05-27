//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import Vapor
import SwiftHtml

public struct NavigationTemplate: TemplateRepresentable {
    
    public let context: NavigationContext
    
    public init(_ context: NavigationContext) {
        self.context = context
    }

    public func render(_ req: Request) -> Tag {
        Nav {
            Label {
                context.icon
            }
            .for("\(context.id)-menu-button")
            Input()
                .type(.checkbox)
                .id("\(context.id)-menu-button")
                        
            Div {
                context.items
            }
            .id("\(context.id)-menu-items")
        }
        .id("\(context.id)-menu")
    }
}
