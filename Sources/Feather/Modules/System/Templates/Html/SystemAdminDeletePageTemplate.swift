//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

public struct SystemAdminDeletePageTemplate: TemplateRepresentable {

    public var context: SystemAdminDeletePageContext

    public init(_ context: SystemAdminDeletePageContext) {
        self.context = context
    }
    
    private var excerpt: String {
        "You are about to permanently delete the<br>`\(context.name)` \(context.type.lowercased())."
    }

    public func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: context.title, excerpt: excerpt)) .render(req)

                    FormTemplate(context.form).render(req)
                    
                    A("Cancel")
                        .href(req.getQuery("cancel") ?? "#")
                }
            }
            .id("delete-confirmation")
        }
        .render(req)
    }
}


