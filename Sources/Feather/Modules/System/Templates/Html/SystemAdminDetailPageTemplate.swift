//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 01..
//

import Vapor
import SwiftHtml

struct SystemAdminDetailPageTemplate: TemplateRepresentable {
    
    var context: SystemAdminDetailPageContext
    
    init(_ context: SystemAdminDetailPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title, breadcrumbs: context.breadcrumbs)) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: context.title, links: context.navigation)).render(req)
                    
                    Dl {
                        context.fields.map { DetailTemplate($0).render(req) }
                    }

                    Section {
                        Nav {
                            context.actions.map { LinkTemplate($0).render(req) }
                        }
                    }
                }
            }
        }
        .render(req)
    }
}


