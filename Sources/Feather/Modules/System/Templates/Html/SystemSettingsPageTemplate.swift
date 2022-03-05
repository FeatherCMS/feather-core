//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor
import SwiftHtml

final class SystemSettingsPageTemplate: AbstractTemplate<SystemSettingsContext> {
    
    override func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: "Settings", breadcrumbs: [
            LinkContext(label: "System", dropLast: 1),
        ])) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Settings")).render(req)
                    
                    FormTemplate(context.form).render(req)
                }
            }
        }
        .render(req)
    }
}


