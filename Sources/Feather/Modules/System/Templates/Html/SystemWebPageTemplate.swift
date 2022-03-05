//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor
import SwiftHtml

final class SystemWebPageTemplate: AbstractTemplate<SystemWebPageContext> {

    override func render(_ req: Request) -> Tag {
        req.app.templateEngine.system.index(.init(title: context.title)) {
            Wrapper {
                Container {
                    H1(context.title)
                    P(context.message)
                }
            }
            .id("welcome-page")
        }
        .render(req)
    }
}
