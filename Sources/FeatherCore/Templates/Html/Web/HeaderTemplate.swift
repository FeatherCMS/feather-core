//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 24..
//

import SwiftHtml

public struct HeaderTemplate: TemplateRepresentable {
    
    public let context: HeaderContext
    
    public init(_ context: HeaderContext) {
        self.context = context
    }
    
    public func render(_ req: Request) -> Tag {
        Header {
            Div {
                A {
                    Picture {
                        Source()
                            .srcset("/img/web/logos/feather-logo-dark.png")
                            .media(.prefersColorScheme(.dark))
                        Img(src: "/img/web/logos/feather-logo.png", alt: "Logo of Feather")
                            .title("Feather")
                    }
                }
                .id("logo")
                .href("/")
                
                if let main = context.main {
                    MenuTemplate(main).render(req)
                }
                if let account = context.account {
                    MenuTemplate(account).render(req)
                }
            }
            .class("safe-area")
        }
        .id("navigation")
        .class("noselect")
    }
}
