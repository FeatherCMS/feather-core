//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 27..
//

import SwiftHtml

public struct AdminDashboardTemplate: TemplateRepresentable {
    
    
    var context: AdminDashboardContext
    
    public init(_ context: AdminDashboardContext) {
        self.context = context
    }

    @TagBuilder
    public func render(_ req: Request) -> Tag {
        AdminIndexTemplate(.init(title: context.title)) {
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
