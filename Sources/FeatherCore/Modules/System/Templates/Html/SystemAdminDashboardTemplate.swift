//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import Vapor
import SwiftHtml

struct SystemAdminDashboardTemplate: TemplateRepresentable {
    
    
    var context: SystemAdminDashboardContext
    
    init(_ context: SystemAdminDashboardContext) {
        self.context = context
    }

    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemAdminIndexTemplate(.init(title: context.title)) {
            Wrapper {
                LeadTemplate(.init(title: "Dashboard",
                                   excerpt: "Overview of the content management system.")).render(req)
                
                Section {
                    context.widgets.map { widget in
                        Div {
                            Div {
                                widget
                            }
                            .class("content")
                        }
                        .class("card")
                    }
                }
                .class("grid-321")
            }
            .id("dashboard")
        }
        .render(req)
    }
}
