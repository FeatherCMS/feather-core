//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Vapor
import SwiftHtml

public struct WebPageTemplate: TemplateRepresentable {

    unowned var req: Request
    public var context: WebPageContext
    
    public init(_ req: Request, context: WebPageContext) {
        self.req = req
        self.context = context
    }
    
    public var tag: Tag {
        WebIndexTemplate(req, context: context.index) {
            H1(context.title)

            Div {
                Text(context.content)
            }
        }.tag
    }
}
