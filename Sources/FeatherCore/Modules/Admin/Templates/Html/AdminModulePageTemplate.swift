//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import SwiftHtml

public struct AdminModulePageTemplate: TemplateRepresentable {
    
    var context: AdminModulePageContext
    
    public init(_ context: AdminModulePageContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title)) {
            Div {
                H1(context.title)
                P(context.message)
            }
            .class("lead")
            
            Section {
                Ul {
                    context.links.map { link in
                        Li {
                            A(link.label)
                                .href(link.path)
                        }
                    }
                }
            }
        }
        .render(req)
    }
}
