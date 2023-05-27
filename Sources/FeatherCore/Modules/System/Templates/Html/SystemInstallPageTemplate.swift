//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 13..
//

import Vapor
import SwiftHtml

public struct SystemInstallPageTemplate: TemplateRepresentable {
    
    var context: SystemInstallPageContext
    
    public init(_ context: SystemInstallPageContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: context.title)) {
            Wrapper {
                Container {
                    LeadTemplate(.init(icon: context.icon,
                                       title: context.title,
                                       excerpt: context.message,
                                       links: [
                                            .init(label: context.link.label, path: context.link.path, absolute: true)
                                       ]))
                        .render(req)
                }
            }
        }
        .render(req)
    }
}
