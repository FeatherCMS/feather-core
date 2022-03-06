//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 22..
//

import Vapor
import SwiftHtml

final class SystemFileCreateDirectoryTemplate: AbstractTemplate<SystemFileCreateDirectoryContext> {

    override func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: "Create directory")) {//, breadcrumbs: [
//            LinkContext(label: "System", dropLast: 2),
//            LinkContext(label: "Files", dropLast: 1),
//        ])) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Create directory")).render(req)
                    FormTemplate(context.form).render(req)
                }
            }
        }
        .render(req)
    }
}


