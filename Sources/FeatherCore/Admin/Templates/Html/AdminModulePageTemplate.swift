//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

public struct AdminModulePageTemplate: TemplateRepresentable {
    
    unowned var req: Request
    var context: AdminModulePageContext
    
    public init(_ req: Request, _ context: AdminModulePageContext) {
        self.req = req
        self.context = context
    }

    public var tag: Tag {
        AdminIndexTemplate(req, .init(title: context.title, breadcrumbs: [])) {
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
                                .href(link.url)
                        }
                    }
                }
            }
        }.tag
    }
}
