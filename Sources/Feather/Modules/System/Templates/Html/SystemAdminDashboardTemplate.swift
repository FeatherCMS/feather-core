//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml

struct SystemAdminDashboardTemplate: TemplateRepresentable {

    let context: SystemAdminDashboardContext
    
    init(_ context: SystemAdminDashboardContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title)) {
            Wrapper {
                H1("Dashboard")
                P("Welcome to the admin interface.")
                
                for group in context.groups {
                    Div {
                        H2(group.title)
                        P(group.excerpt)
                    }
                    .class("lead")

                    Section {
                        group.tags.map { tag in
                            Div {
                                Div {
                                    tag
                                }
                                .class("content")
                            }
                            .class("card")
                        }
                    }
                    .class("grid-321")
                }
            }
            .id("dashboard")
        }
        .render(req)
    }
}
