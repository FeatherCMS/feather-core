//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml

public struct MenuTemplate: TemplateRepresentable {
    
    public let context: MenuContext
    
    public init(_ context: MenuContext) {
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
