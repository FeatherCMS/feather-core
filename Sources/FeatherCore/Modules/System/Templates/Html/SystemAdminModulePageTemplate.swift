//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Vapor
import SwiftHtml

public struct SystemAdminModulePageTemplate: TemplateRepresentable {
    
    var context: SystemAdminModulePageContext
    
    public init(_ context: SystemAdminModulePageContext) {
        self.context = context
    }
    
    @TagBuilder
    public func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title)) {
            Wrapper {
                Container {
                    context.tag       
                }
                .class(add: "module-page")
            }
        }
        .render(req)
    }
}
